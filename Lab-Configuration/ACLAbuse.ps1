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

Add-ADGroupMember -Identity 'Office Admins' -Members 'jane.doe'

New-ADComputer -Name "SRV2-000" -SamAccountName "SRV2-000" -Path "OU=ApplicationServers,DC=aclabuse,DC=lab"

# WriteProperty
$targetDN =  "AD:"+(Get-ADGroup -Identity 'Domain Users').DistinguishedName
$targetACL = Get-ACL -Path $targetDN
$groupSID = (Get-ADGroup -Identity 'Office Admins').SID
$ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
    $groupSID,
    [System.DirectoryServices.ActiveDirectoryRights]::WriteProperty,
    [System.Security.AccessControl.AccessControlType]::Allow
    )
$targetACL.SetAccessRuleProtection($true, $true)
$targetACL.SetAccessRule($ace)
Set-Acl -AclObject $objectACL -Path $targetDN

# Self
# WriteOwner
# WriteDACL
# GenericWrite
# GenericAll