<#
.SYNOPSIS
    This PowerShell script ensures that Wi-Fi Sense is disabled.

.NOTES
    Author          : Jerrell Williams
    GitHub          : github.com/JerrellW1
    Date Created    : 2025-03-16
    Last Modified   : 2025-03-16
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000065

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\STIG-ID-WN10-CC-000065.ps1 
#>

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config"
$registryKey = "AutoConnectAllowedOEM"
$desiredValue = 0x00000000  # 0 in hexadecimal (Disabling AutoConnect for OEM Wi-Fi networks)

# Check if the registry path exists, and create it if it doesn't
if (-not (Test-Path $registryPath)) {
    Write-Host "Registry path $registryPath does not exist. Creating the path..."
    New-Item -Path $registryPath -Force | Out-Null
    Write-Host "Registry path created."
}

# Check if the registry value exists
$currentValue = Get-ItemProperty -Path $registryPath -Name $registryKey -ErrorAction SilentlyContinue

if ($currentValue -eq $null -or $currentValue.AutoConnectAllowedOEM -ne $desiredValue) {
    # The value doesn't exist or it's set to a value different from the desired one
    Write-Host "Configuring the registry value AutoConnectAllowedOEM to $desiredValue..."
    Set-ItemProperty -Path $registryPath -Name $registryKey -Value $desiredValue
    Write-Host "Registry value AutoConnectAllowedOEM set to $desiredValue."
} else {
    Write-Host "Registry value AutoConnectAllowedOEM is already correctly configured."
}
