$domainName = "gpoabuse.lab"
$ou = "OU=EnterpriseUsers,DC=gpoabuse,DC=lab"

New-ADOrganizationalUnit -Name "EnterpriseUsers" -Path "DC=gpoabuse,DC=lab"

New-ADUser -Name "John Dee" `
    -GivenName "John" -Surname "Dee" `
    -SamAccountName "john.dee" `
    -UserPrincipalName ("John.Dee@" + $domainName) `
    -AccountPassword (ConvertTo-SecureString "johnsPass01" -AsPlainText -Force) `
    -Path $ou -PassThru | Enable-ADAccount

New-ADUser -Name "Jim Duggan" `
    -GivenName "Jim" -Surname "Duggan" `
    -SamAccountName "jim.duggan" `
    -UserPrincipalName ("Jim.Duggan@" + $domainName) `
    -AccountPassword (ConvertTo-SecureString "jimsPass01" -AsPlainText -Force) `
    -Path $ou -PassThru | Enable-ADAccount

New-ADGroup -Name "Office Admins" -GroupScope Global -Path $ou  
New-ADGroup -Name "Policy Admins" -GroupScope Global -Path $ou
Add-ADGroupMember -Identity "Office Admins" -Members "john.dee"
Add-ADGroupMember -Identity "Policy Admins" -Members "jim.duggan"
Add-ADGroupMember -Identity "Group Policy Creator Owners" -Members "Policy Admins"
Add-ADGroupMember -Identity "Remote Management Users" -Members "Policy Admins"

# adapted from https://raw.githubusercontent.com/Orange-Cyberdefense/GOAD/refs/heads/main/ad/GOAD/scripts/gpo_abuse.ps1
Install-WindowsFeature -Name GPMC
$gpo_exist = Get-GPO -Name "Set Wallpaper" -erroraction ignore

if ($gpo_exist) {
    # pass
} else {
    New-GPO -Name "SetWallapper" -comment "Office admins can set the wallpaper"
    New-GPLink -Name "SetWallapper" -Target $ou
    Set-GPRegistryValue -Name "SetWallapper" -key "HKEY_CURRENT_USER\Control Panel\Colors" -ValueName Background -Type String -Value "100 175 200"
    Set-GPRegistryValue -Name "SetWallapper" -key "HKEY_CURRENT_USER\Control Panel\Desktop" -ValueName Wallpaper -Type String -Value ""
    Set-GPRegistryValue -Name "SetWallapper" -Key "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows NT\CurrentVersion\WinLogon" -ValueName SyncForegroundPolicy -Type DWORD -Value 1
    Set-GPPermissions -Name "SetWallapper" -PermissionLevel GpoEditDeleteModifySecurity -TargetName "Office Admins" -TargetType "Group"
}

<#
Attack Path

The attacker gains initial access to the network and discovers John's account has a weak password.

After accessing John's account, initial recon shows John is part of the IT Admins group.

The Office Admins group has GenericWrite on the GPO "SetWallpaper" - obviously to set the wallpaper for devices in the OU.

The attacker modifies the GPO \\gpoabuse.lab\SYSVOL\gpoabuse.lab\Policies\{GPO_GUID}\ to change the GPO to one that grants him take ownership privileges.

User rights dont require logging in, so we just wait for the GPO to reapply (90 =/- 30 mins, but we will force this with an admin gpudate to save time)

The attacker takes over the 

#>