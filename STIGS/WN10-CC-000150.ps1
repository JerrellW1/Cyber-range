<#
.SYNOPSIS
    This PowerShell script ensures that the user must be prompted for a password on resume from sleep (plugged in).
    
    Author          : Jerrell Williams
    GitHub          : github.com/JerrellW1
    Date Created    : 2025-03-18
    Last Modified   : 2025-03-18
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000150

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\STIG-ID-WN10-CC-000150.ps1 
#>

# Define the registry path and value for ACSettingIndex
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51"
$regName = "ACSettingIndex"
$regValue = 1  # 1 = Enabled (requires a password when waking from sleep while plugged in)

# Check if the registry path exists
if (Test-Path $regPath) {
    # Set the value for ACSettingIndex if it's not already set
    Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Force
    Write-Host "Successfully configured ACSettingIndex registry value to $regValue."
} else {
    Write-Host "Registry path does not exist. Creating the path and setting the value."
    # Create the path and set the value
    New-Item -Path $regPath -Force | Out-Null
    Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Force
    Write-Host "Successfully created the registry key and configured ACSettingIndex registry value to $regValue."
}

# Force Group Policy Update to apply changes
gpupdate /force

Write-Host "ACSettingIndex registry value has been configured. Please restart the system for the policy to take full effect."
