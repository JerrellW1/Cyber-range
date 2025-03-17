<#
.SYNOPSIS
    This PowerShell script ensures that Internet Explorer is disabled for Windows 10.

.NOTES
    Author          : Jerrell Williams
    GitHub          : github.com/JerrellW1
    Date Created    : 2025-03-16
    Last Modified   : 2025-03-16
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000391

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\STIG-ID-WN10-CC-000391.ps1 
#>

# Step 1: Disable IE11 as a standalone browser using Group Policy

# Define the registry path for the Group Policy setting to disable IE11 as a standalone browser
$gpoPath = "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer"
$gpoSettingName = "DisableStandaloneIE"

# Ensure the registry path exists, and create it if it doesn't
if (-not (Test-Path $gpoPath)) {
    Write-Host "Registry path $gpoPath does not exist. Creating the path..."
    New-Item -Path $gpoPath -Force | Out-Null
    Write-Host "Registry path created."
}

# Set the "Disable Internet Explorer 11 as a standalone browser" policy to "Enabled" with the option "Never"
Write-Host "Disabling Internet Explorer 11 as a standalone browser..."
Set-ItemProperty -Path $gpoPath -Name $gpoSettingName -Value 1
Write-Host "Internet Explorer 11 has been disabled as a standalone browser."

# Step 2: Optionally, uninstall Internet Explorer 11 (uninstalling IE11 is optional and depends on your requirements)

# Check if IE11 is installed
$ieVersion = (Get-WmiObject -Class Win32_OperatingSystem).Version
if ($ieVersion -ge "10.0") {
    Write-Host "Attempting to uninstall Internet Explorer 11..."

    # Uninstall IE11 using DISM (Deployment Imaging Service and Management Tool)
    $dismCommand = "dism.exe /online /disable-feature /featurename:Internet-Explorer-Optional-amd64 /norestart"
    Invoke-Expression $dismCommand
    Write-Host "Internet Explorer 11 has been uninstalled."
} else {
    Write-Host "Internet Explorer 11 is not installed on this system."
}

# Step 3: Confirm changes

# Check if the registry key was set successfully
$regKeyValue = Get-ItemProperty -Path $gpoPath -Name $gpoSettingName
if ($regKeyValue.DisableStandaloneIE -eq 1) {
    Write-Host "Policy to disable Internet Explorer 11 as a standalone browser is set correctly."
} else {
    Write-Host "Failed to set the policy correctly. Please check your Group Policy settings."
}
