<#
.SYNOPSIS
    This PowerShell script disables and uninstalls the TFTP Client if installed

.NOTES
    Author          : Jerrell Williams
    GitHub          : github.com/JerrellW1
    Date Created    : 2025-03-15
    Last Modified   : 2025-03-15
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-00-000120

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\STIG-ID-WN10-00-000120.ps1 
#>

# PowerShell script to disable and uninstall the TFTP Client if installed

# Check if TFTP Client is installed
$tftpFeature = Get-WindowsOptionalFeature -FeatureName "TFTP" -Online

# If TFTP Client is enabled, disable and uninstall it
if ($tftpFeature.State -eq 'Enabled') {
    Write-Host "TFTP Client is installed and enabled. Disabling and uninstalling..."

    # Disable the TFTP Client feature (deselecting it)
    Disable-WindowsOptionalFeature -FeatureName "TFTP" -Online -NoRestart
    Write-Host "TFTP Client has been deselected (disabled)."

    # Uninstall the TFTP Client feature
    Uninstall-WindowsFeature -FeatureName "TFTP"
    Write-Host "TFTP Client has been uninstalled."
} else {
    Write-Host "TFTP Client is not installed or already disabled."
}

# Final confirmation message
Write-Host "TFTP Client disable/uninstall script executed successfully."
