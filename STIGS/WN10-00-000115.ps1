<#
.SYNOPSIS
    This PowerShell script ensures that the Telnet client is disabled and uninstalled.

.NOTES
    Author          : Jerrell Williams
    GitHub          : github.com/JerrellW1
    Date Created    : 2025-03-15
    Last Modified   : 2025-03-15
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-00-000115

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\STIG-ID-WN10-00-000115.ps1 
#>

# PowerShell script to disable and uninstall the Telnet Client if installed

# Check if Telnet Client is installed
$telnetFeature = Get-WindowsOptionalFeature -FeatureName "TelnetClient" -Online

# If Telnet Client is enabled, disable and uninstall it
if ($telnetFeature.State -eq 'Enabled') {
    Write-Host "Telnet Client is installed and enabled. Disabling and uninstalling..."

    # Disable the Telnet Client feature (deselecting it)
    Disable-WindowsOptionalFeature -FeatureName "TelnetClient" -Online -NoRestart
    Write-Host "Telnet Client has been deselected (disabled)."

    # Uninstall the Telnet Client feature
    Uninstall-WindowsFeature -FeatureName "TelnetClient"
    Write-Host "Telnet Client has been uninstalled."
} else {
    Write-Host "Telnet Client is not installed or already disabled."
}

# Final confirmation message
Write-Host "Telnet Client disable/uninstall script executed successfully."
