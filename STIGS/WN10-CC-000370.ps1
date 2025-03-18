<#
.SYNOPSIS
    This PowerShell script ensures that the convenience PIN for Windows 10 is disabled.

    Author          : Jerrell Williams
    GitHub          : github.com/JerrellW1
    Date Created    : 2025-03-17
    Last Modified   : 2025-03-17
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000370

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\STIG-ID-WN10-CC-000370.ps1 
#>

# Define the registry path and value for AllowDomainPINLogon
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
$regName = "AllowDomainPINLogon"
$regValue = 0  # 0 = Disabled, 1 = Enabled

# Check if the registry path exists
if (Test-Path $regPath) {
    # Set the value for AllowDomainPINLogon if it's not already set
    Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Force
    Write-Host "Successfully configured AllowDomainPINLogon to 0 (disabled)."
} else {
    Write-Host "Registry path does not exist. Creating the path and setting the value."
    # Create the path and set the value
    New-Item -Path $regPath -Force | Out-Null
    Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Force
    Write-Host "Successfully created the registry key and configured AllowDomainPINLogon to 0 (disabled)."
}

# Set the "Turn on convenience PIN sign-in" policy to "Disabled"
$gpRegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
$gpValueName = "AllowDomainPINLogon"
$gpValue = 0  # 0 = Disabled

# Ensure the registry path exists for the "Turn on convenience PIN sign-in" policy
if (Test-Path $gpRegistryPath) {
    Set-ItemProperty -Path $gpRegistryPath -Name $gpValueName -Value $gpValue -Force
    Write-Host "Successfully disabled convenience PIN sign-in."
} else {
    Write-Host "Creating registry path for 'Turn on convenience PIN sign-in' policy and disabling it."
    New-Item -Path $gpRegistryPath -Force | Out-Null
    Set-ItemProperty -Path $gpRegistryPath -Name $gpValueName -Value $gpValue -Force
    Write-Host "Disabled convenience PIN sign-in."
}

# Force Group Policy Update
gpupdate /force

Write-Host "Convenience PIN sign-in has been disabled. Please restart the system for the policy to take full effect."
