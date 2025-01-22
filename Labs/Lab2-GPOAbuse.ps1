# Global variables
$labName = 'GPOAbuse'
$domainName = 'gpoabuse.lab'
$admin = 'gpoAdmin'
$adminPass = 'gpoPass01'
$machineNameDC = 'DC01'
$machineAddressDC = '192.168.6.10'
$machineNameWS = 'WS01'
$machineAddressWS = '192.168.6.88'

# Change the labISO_X variables to match the ISOs you have available
$labISO_DC = 'Windows Server 2019 Standard (Desktop Experience)'
$labISO_WS = 'Windows 11 Pro'

# Lab defintion
New-LabDefinition `
    -Name $labName `
    -DefaultVirtualizationEngine HyperV

# lab network, do not alter the AddressSpace without also changing the $machineAddress
Add-LabVirtualNetworkDefinition `
    -Name $labName `
    -AddressSpace 192.168.6.0/24

# Lab credentials, these can be configured in the global variables at the top of the script
Set-LabInstallationCredential `
    -Username $admin `
    -Password $adminPass

# Active directory domain defintion
Add-LabDomainDefinition `
    -Name $domainName `
    -AdminUser $admin `
    -AdminPassword $adminPass

# The lab configuration script is defined here as a post install activity
$scriptPath = Join-Path $PSScriptRoot '.\Lab-Configuration'
$labConfigDC = Get-LabInstallationActivity -ScriptFileName 'GPOAbuse-DC01.ps1' -DependencyFolder $scriptPath
$labConfigWS = Get-LabInstallationActivity -ScriptFileName 'GPOAbuse-WS01.ps1' -DependencyFolder $scriptPath

# Definition for DC01
Add-LabMachineDefinition `
    -Name $machineNameDC `
    -MinMemory 512MB `
    -Memory 1GB `
    -MaxMemory 2GB `
    -Network $labName `
    -IpAddress $machineAddressDC `
    -DnsServer1 $machineAddressDC `
    -DomainName $domainName `
    -Roles RootDC `
    -OperatingSystem $labISO_DC `
    -PostInstallationActivity $labConfigDC

# Definition for WS01
# Make sure the DnsServer is set to DC01's IP Address
Add-LabMachineDefinition `
    -Name $machineNameWS `
    -MinMemory 512MB `
    -Memory 1GB `
    -MaxMemory 2GB `
    -Network $labName `
    -IpAddress $machineAddressWS `
    -DnsServer1 $machineAddressDC `
    -DomainName $domainName `
    -OperatingSystem $labISO_WS `
    -PostInstallationActivity $labConfigWS

# Install lab & report
Install-Lab
Show-LabDeploymentSummary -Detailed 

# Set up the vEthernet interface on the host to use the newly created DC as its DNS server
$index = (Get-NetAdapter | Where-Object Name -Match $labName).ifIndex
Set-DnsClientServerAddress -InterfaceIndex $index -ServerAddresses $machineAddressDC
Write-Host "Host vEthernet interface configured..."
Get-NetIPConfiguration -InterfaceIndex $index