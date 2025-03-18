<#
.SYNOPSIS
    This PowerShell script ensures that Autoplay is disabled for all drives.

.NOTES
    Author          : Jerrell Williams
    GitHub          : github.com/JerrellW1
    Date Created    : 2025-03-17
    Last Modified   : 2025-03-17
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000190

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\STIG-ID-WN10-CC-000190.ps1 
#>

# Define the registry path and value for NoDriveTypeAutoRun
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$regName = "NoDriveTypeAutoRun"
$regValue = 0x000000ff  # 255 in decimal, 0xFF in hexadecimal

# Check if the registry path exists
if (Test-Path $regPath) {
    # Set the value for NoDriveTypeAutoRun if it's not already set
    Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Force
    Write-Host "Successfully configured NoDriveTypeAutoRun to 0x000000ff."
} else {
    Write-Host "Registry path does not exist. Creating the path and setting the value."
    # Create the path and set the value
    New-Item -Path $regPath -Force | Out-Null
    Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Force
    Write-Host "Successfully created the registry key and configured NoDriveTypeAutoRun to 0x000000ff."
}

# Set the "Turn off AutoPlay" policy to "Enabled: All Drives"
$gpRegistryPath = "HKCU:\Software\Policies\Microsoft\Windows\Explorer"
$gpValueName = "NoDriveTypeAutoRun"
$gpValue = 1 # Enabled for all drives

# Ensure the registry path exists for the "Turn off AutoPlay" policy
if (Test-Path $gpRegistryPath) {
    Set-ItemProperty -Path $gpRegistryPath -Name "TurnOffAutoPlay" -Value 1 -Force
    Write-Host "Successfully enabled 'Turn off AutoPlay' for all drives."
} else {
    Write-Host "Creating registry path for 'Turn off AutoPlay' policy and enabling it."
    New-Item -Path $gpRegistryPath -Force | Out-Null
    Set-ItemProperty -Path $gpRegistryPath -Name "TurnOffAutoPlay" -Value 1 -Force
    Write-Host "'Turn off AutoPlay' policy enabled for all drives."
}

# Force Group Policy Update
gpupdate /force

Write-Host "Both the NoDriveTypeAutoRun registry setting and 'Turn off AutoPlay' policy have been successfully applied. Please restart the system for the policy to take full effect."
