New-ADOrganizationalUnit -Name "EnterpriseUsers" -Path "DC=aclabuse,DC=lab"
New-ADOrganizationalUnit -Name "ApplicationServers" -Path "DC=aclabuse,DC=lab"

New-ADUser -Name 'Jane Doe' `
    -GivenName 'Jane' -Surname 'Doe' `
    -SamAccountName 'jane.doe' `
    -UserPrincipalName ('Jane.Doe@' + $domainName) `
    -AccountPassword (ConvertTo-SecureString 'janesPass01' -AsPlainText -Force) `
    -Path 'OU=EnterpriseUsers,DC=aclabuse,DC=lab' | Enable-ADAccount

New-ADUser -Name 'John Dee' `
    -GivenName 'Jane' -Surname 'Dee' `
    -SamAccountName 'john.dee' `
    -UserPrincipalName ('John.Dee@' + $domainName) `
    -AccountPassword (ConvertTo-SecureString 'johnsPass01' -AsPlainText -Force) `
    -Path "OU=EnterpriseUsers,DC=aclabuse,DC=lab" | Enable-ADAccount

foreach ($group in  @('Office Admins','IT Admins','DevOps')) {
    New-ADGroup -Name $group -GroupScope Global -Path 'OU=EnterpriseUsers,DC=aclabuse,DC=lab'
}

New-ADComputer -Name "SRV2-000" -SamAccountName "SRV2-000" -Path "OU=ApplicationServers,DC=aclabuse,DC=lab"

# Self

# WriteProperty
$groupDN =  "AD:"+$(Get-ADGroup -Filter {Name -eq 'Account Operators'}).DistinguishedName
$objectACL = Get-ACL -Path $groupDN
$userSid = (Get-ADUser -Filter {Name -eq 'Jane Doe'}).SID
$ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
    $userSid,
    [System.DirectoryServices.ActiveDirectoryRights]::WriteProperty,
    [System.Security.AccessControl.AccessControlType]::Allow
    )
$objectACL.SetAccessRuleProtection($true, $true)
$objectACL.SetAccessRule($ace)
Set-Acl -AclObject $objectACL -Path $groupDN

# WriteDACL
# WriteOwner
# GenericWrite
# GenericAll