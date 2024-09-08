$domainName = 'aclabuse.lab'

New-ADOrganizationalUnit -Name "EnterpriseUsers" -Path "DC=aclabuse,DC=lab"
New-ADOrganizationalUnit -Name "ApplicationServers" -Path "DC=aclabuse,DC=lab"

New-ADUser -Name 'Jane Doe' `
    -GivenName 'Jane' -Surname 'Doe' `
    -SamAccountName 'jane.doe' `
    -UserPrincipalName ('Jane.Doe@' + $domainName) `
    -AccountPassword (ConvertTo-SecureString 'janesPass01' -AsPlainText -Force) `
    -Path 'OU=EnterpriseUsers,DC=aclabuse,DC=lab' -PassThru | Enable-ADAccount

New-ADUser -Name 'John Dee' `
    -GivenName 'Jane' -Surname 'Dee' `
    -SamAccountName 'john.dee' `
    -UserPrincipalName ('John.Dee@' + $domainName) `
    -AccountPassword (ConvertTo-SecureString 'johnsPass01' -AsPlainText -Force) `
    -Path "OU=EnterpriseUsers,DC=aclabuse,DC=lab" -PassThru | Enable-ADAccount

foreach ($group in  @('Office Admins','IT Admins','DevOps')) {
    New-ADGroup -Name $group -GroupScope Global -Path 'OU=EnterpriseUsers,DC=aclabuse,DC=lab'
}

Add-ADGroupMember -Identity 'IT Admins' -Members 'jane.doe'
Add-ADGroupMember -Identity 'Office Admins' -Members 'john.dee'

New-ADComputer -Name "SRV2-000" -SamAccountName "SRV2-000" -Path "OU=ApplicationServers,DC=aclabuse,DC=lab"

# WriteProperty
$targetDN =  "AD:$(Get-ADGroup -Identity 'Office Admins')"
$targetACL = Get-ACL -Path $targetDN
$groupSID = (Get-ADGroup -Identity 'Office Admins').SID
$ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
    $groupSID,
    [System.DirectoryServices.ActiveDirectoryRights]::WriteProperty,
    [System.Security.AccessControl.AccessControlType]::Allow
    )
$targetACL.SetAccessRule($ace)
Set-Acl -AclObject $targetACL -Path $targetDN

<#
Attack Path

Reconnaissance:
The attacker gains initial access to the network and discovers John's account has a weak password.

Initial Compromise (WriteProperty):

The attacker compromises John's account.

Jane has WriteProperty rights on John's account for the 'scriptPath' attribute.
Attacker modifies John's scriptPath to include a malicious script that will run on John's next login.


Lateral Movement (Self):

John logs in, executing the malicious script.
The script exploits John's "Self" permissions on his account to add his account to the "Office Admins" group.


Privilege Escalation (WriteDACL):

As a member of "Office Admins", John has WriteDACL permissions on the "IT Admins" group.
The attacker, through John's account, modifies the DACL of "IT Admins" to grant John's account GenericWrite permissions.


Further Compromise (GenericWrite):

Using the newly acquired GenericWrite permissions on "IT Admins", the attacker adds John to this group.
As an "IT Admin", John now has elevated privileges across various systems.


Domain Dominance (GenericAll):

The "IT Admins" group has GenericAll permissions on the "DevOps Admins" group.
The attacker, through John's "IT Admin" privileges, grants John's account direct membership in "DevOps Admins".
"DevOps Admins" has extensive privileges, including potential access to critical infrastructure and deployment pipelines.
#>