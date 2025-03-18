<#
.SYNOPSIS
    This PowerShell script ensures that Users must be prompted for a password on resume from sleep (on battery).
    
    Author          : Jerrell Williams
    GitHub          : github.com/JerrellW1
    Date Created    : 2025-03-17
    Last Modified   : 2025-03-17
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000145

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\STIG-ID-WN10-CC-000145.ps1 
#>

# Define the registry path and value for DCSettingIndex
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51"
$regName = "DCSettingIndex"
$regValue = 1  # 1 = Enabled, typically requires a password on wake from sleep

# Check if the registry path exists
if (Test-Path $regPath) {
    # Set the value for DCSettingIndex if it's not already set
    Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Force
    Write-Host "Successfully configured DCSettingIndex registry value to $regValue."
} else {
    Write-Host "Registry path does not exist. Creating the path and setting the value."
    # Create the path and set the value
    New-Item -Path $regPath -Force | Out-Null
    Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Force
    Write-Host "Successfully created the registry key and configured DCSettingIndex registry value to $regValue."
}

# Force Group Policy Update for sleep settings
gpupdate /force

Write-Host "DCSettingIndex registry value has been configured. Please restart the system for the policy to take full effect."
