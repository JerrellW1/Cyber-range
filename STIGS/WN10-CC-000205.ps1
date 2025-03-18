<#
.SYNOPSIS
    This PowerShell script ensures that Windows Telemetry must not be configured to Full.
    
    Author          : Jerrell Williams
    GitHub          : github.com/JerrellW1
    Date Created    : 2025-03-17
    Last Modified   : 2025-03-17
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000205

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\STIG-ID-WN10-CC-000205.ps1 
#>

# Define the registry path and value for AllowTelemetry
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
$regName = "AllowTelemetry"

# Define the desired value for AllowTelemetry (0 = Security, 1 = Basic, 2 = Enhanced)
# Change this value based on your organization's policy
$regValue = 0  # 0 = Security, 1 = Basic, 2 = Enhanced

# Check if the registry path exists
if (Test-Path $regPath) {
    # Set the value for AllowTelemetry if it's not already set
    Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Force
    Write-Host "Successfully configured AllowTelemetry registry value to $regValue."
} else {
    Write-Host "Registry path does not exist. Creating the path and setting the value."
    # Create the path and set the value
    New-Item -Path $regPath -Force | Out-Null
    Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Force
    Write-Host "Successfully created the registry key and configured AllowTelemetry registry value to $regValue."
}

# Configure the Group Policy setting for "Allow Telemetry"
# This will configure the Group Policy to be enabled and the selected option (0 for Security, 1 for Basic, or 2 for Enhanced)

# First, define the appropriate value for the policy option
$gpValue = $regValue  # Set to the same value as in the registry

# Define the path for the Group Policy registry key
$gpRegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
$gpPolicyName = "AllowTelemetry"

# Check if the Group Policy path exists
if (Test-Path $gpRegPath) {
    # Set the Group Policy for Allow Telemetry
    Set-ItemProperty -Path $gpRegPath -Name $gpPolicyName -Value $gpValue -Force
    Write-Host "Successfully configured Group Policy for AllowTelemetry with value $gpValue."
} else {
    Write-Host "Group Policy registry path does not exist. Creating the path and setting the value."
    # Create the Group Policy path and set the value
    New-Item -Path $gpRegPath -Force | Out-Null
    Set-ItemProperty -Path $gpRegPath -Name $gpPolicyName -Value $gpValue -Force
    Write-Host "Successfully created the Group Policy registry key and configured AllowTelemetry with value $gpValue."
}

# Force Group Policy Update
gpupdate /force

Write-Host "AllowTelemetry registry value and Group Policy settings have been configured. Please restart the system for the policy to take full effect."
