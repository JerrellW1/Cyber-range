<#
.SYNOPSIS
    This PowerShell script ensures that the Camera access from the lock screen is disabled.

.NOTES
    Author          : Jerrell Williams
    GitHub          : github.com/JerrellW1
    Date Created    : 2025-03-15
    Last Modified   : 2025-03-15
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000005

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\STIG-ID-WN10-CC-000005.ps1 
#>

# PowerShell script to modify the registry value NoLockScreenCamera

# Define the registry path and value
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
$valueName = "NoLockScreenCamera"
$valueData = 1

# Check if the registry path exists, if not, create it
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force
}

# Set the registry value
Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData -Type DWord

# Confirm the update
Write-Host "Registry updated: $valueName set to $valueData"
