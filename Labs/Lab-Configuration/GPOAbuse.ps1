$domainName = 'gpoabuse.lab'

New-ADOrganizationalUnit -Name "EnterpriseUsers" -Path "DC=aclabuse,DC=lab"
New-ADOrganizationalUnit -Name "SecurityUsers" -Path "DC=aclabuse,DC=lab"

New-ADUser -Name 'John Dee' `
    -GivenName 'John' -Surname 'Dee' `
    -SamAccountName 'john.dee' `
    -UserPrincipalName ('John.Dee@' + $domainName) `
    -AccountPassword (ConvertTo-SecureString 'johnsPass01' -AsPlainText -Force) `
    -Path "OU=EnterpriseUsers,DC=aclabuse,DC=lab" -PassThru | Enable-ADAccount

New-ADUser -Name 'Jane Doe' `
    -GivenName 'Jane' -Surname 'Doe' `
    -SamAccountName 'jane.doe' `
    -UserPrincipalName ('Jane.Doe@' + $domainName) `
    -AccountPassword (ConvertTo-SecureString 'janesPass01' -AsPlainText -Force) `
    -Path "OU=SecurityUsers,DC=aclabuse,DC=lab" -PassThru | Enable-ADAccount

foreach ($group in  @('Office Admins','IT Admins','DevOps Admins')) {
    New-ADGroup -Name $group -GroupScope Global -Path 'OU=EnterpriseUsers,DC=aclabuse,DC=lab'
}

New-ADGroup -Name 'SOC' -GroupScope Global

Add-ADGroupMember -Identity 'Domain Admins' -Members 'SOC'

Add-ADGroupMember -Identity 'SOC' -Members 'jane.doe'

Add-ADGroupMember -Identity 'Office Admins' -Members 'john.dee'

<#
Attack Path

The attacker gains initial access to the network and discovers John's account has a weak password.

...

#>