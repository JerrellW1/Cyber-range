<#
.SYNOPSIS
    This PowerShell script ensures that Microsoft's consumer experience is turned off.
    
    Author          : Jerrell Williams
    GitHub          : github.com/JerrellW1
    Date Created    : 2025-03-18
    Last Modified   : 2025-03-18
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000197

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\STIG-ID-WN10-CC-000197.ps1 
#>

# Define the registry path and value for DisableWindowsConsumerFeatures
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
$regName = "DisableWindowsConsumerFeatures"
$regValue = 1  # 1 = Disabled (turn off consumer features)

# Check if the registry path exists
if (Test-Path $regPath) {
    # Set the value for DisableWindowsConsumerFeatures if it's not already set
    Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Force
    Write-Host "Successfully configured DisableWindowsConsumerFeatures registry value to $regValue."
} else {
    Write-Host "Registry path does not exist. Creating the path and setting the value."
    # Create the path and set the value
    New-Item -Path $regPath -Force | Out-Null
    Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Force
    Write-Host "Successfully created the registry key and configured DisableWindowsConsumerFeatures registry value to $regValue."
}

# Force Group Policy Update to apply changes
gpupdate /force

Write-Host "DisableWindowsConsumerFeatures registry value has been configured. Please restart the system for the policy to take full effect."
