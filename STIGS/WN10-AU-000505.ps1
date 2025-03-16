<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Security event log is at least 1024000 KB or greater.

.NOTES
    Author          : Jerrell Williams
    GitHub          : github.com/JerrellW1
    Date Created    : 2025-03-16
    Last Modified   : 2025-03-16
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000505

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\STIG-ID-WN10-AU-000505.ps1 
#>

# Registry Path and Value Name
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security"
$registryKey = "MaxSize"
$desiredValue = 0x000FA000 # 1024000 in hexadecimal

# Check if the registry path exists, and create it if it doesn't
if (-not (Test-Path $registryPath)) {
    Write-Host "Registry path $registryPath does not exist. Creating the path..."
    New-Item -Path $registryPath -Force | Out-Null
    Write-Host "Registry path created."
}

# Check if the registry value exists
$currentValue = Get-ItemProperty -Path $registryPath -Name $registryKey -ErrorAction SilentlyContinue

if ($currentValue -eq $null -or $currentValue.MaxSize -lt $desiredValue) {
    # The value doesn't exist or it's set to a value less than the desired one
    Write-Host "Configuring the registry value MaxSize to $desiredValue..."
    Set-ItemProperty -Path $registryPath -Name $registryKey -Value $desiredValue
    Write-Host "Registry value MaxSize set to $desiredValue."
} else {
    Write-Host "Registry value MaxSize is already correctly configured."
}
