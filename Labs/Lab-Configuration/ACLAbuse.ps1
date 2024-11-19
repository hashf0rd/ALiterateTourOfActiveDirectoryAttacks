$domainName = 'aclabuse.lab'

New-ADOrganizationalUnit -Name "EnterpriseUsers" -Path "DC=aclabuse,DC=lab"

New-ADUser -Name 'John Dee' `
    -GivenName 'Jane' -Surname 'Dee' `
    -SamAccountName 'john.dee' `
    -UserPrincipalName ('John.Dee@' + $domainName) `
    -AccountPassword (ConvertTo-SecureString 'johnsPass01' -AsPlainText -Force) `
    -Path "OU=EnterpriseUsers,DC=aclabuse,DC=lab" -PassThru | Enable-ADAccount

foreach ($group in  @('Office Admins','IT Admins','DevOps Admins')) {
    New-ADGroup -Name $group -GroupScope Global -Path 'OU=EnterpriseUsers,DC=aclabuse,DC=lab'
}

Add-ADGroupMember -Identity 'Office Admins' -Members 'john.dee'

<#
Attack Path

The attacker gains initial access to the network and discovers John's account has a weak password.

After the attacker compromises John's account, recon shows that John is part of the Office Admins group.

Mmebers of the "Office Admins" group have WriteProperty over "DevOps Admins", so John is able to add himself to that group.

As a member of "DevOps Admins", John has WriteDACL permissions on the "IT Admins" group.

The attacker, through John's account, modifies the DACL of "IT Admins" to grant John's account GenericWrite permissions.

Using the newly acquired GenericWrite permissions on "IT Admins", the attacker adds John to this group.

The "IT Admins" group has GenericAll permissions on the "AdminSDHolder" object - the template for admin accounts.

Using the GenericAll permissions, the attack makes John a domain admin.

#>

# Office Admins has WriteProperty on DevOps Admins
$targetDN =  "AD:$(Get-ADGroup -Identity 'DevOps Admins')"
$targetACL = Get-ACL -Path $targetDN
$groupSID = (Get-ADGroup -Identity 'Office Admins').SID
$ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
    $groupSID,
    [System.DirectoryServices.ActiveDirectoryRights]::WriteProperty,
    [System.Security.AccessControl.AccessControlType]::Allow
    )
$targetACL.SetAccessRule($ace)
Set-Acl -AclObject $targetACL -Path $targetDN

# DevOps Admins has WriteDACL on IT Admins
$targetDN =  "AD:$(Get-ADGroup -Identity 'IT Admins')"
$targetACL = Get-ACL -Path $targetDN
$groupSID = (Get-ADGroup -Identity 'DevOps Admins').SID
$ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
    $groupSID,
    [System.DirectoryServices.ActiveDirectoryRights]::WriteDacl,
    [System.Security.AccessControl.AccessControlType]::Allow
    )
$targetACL.SetAccessRule($ace)
Set-Acl -AclObject $targetACL -Path $targetDN

# GenericAll
$targetDN =  "AD:CN=AdminSDHolder,CN=System,DC=aclabuse,DC=lab"
$targetACL = Get-ACL -Path $targetDN
$groupSID = (Get-ADGroup -Identity 'IT Admins').SID
$ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
    $groupSID,
    [System.DirectoryServices.ActiveDirectoryRights]::GenericAll,
    [System.Security.AccessControl.AccessControlType]::Allow
    )
$targetACL.SetAccessRule($ace)
Set-Acl -AclObject $targetACL -Path $targetDN