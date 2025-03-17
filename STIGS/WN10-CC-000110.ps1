<#
.SYNOPSIS
    This PowerShell script ensures that Printing over HTTP is prevented.

.NOTES
    Author          : Jerrell Williams
    GitHub          : github.com/JerrellW1
    Date Created    : 2025-03-16
    Last Modified   : 2025-03-16
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000110

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\STIG-ID-WN10-CC-000110.ps1 
#>

# Define the registry path, value name, and desired value
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers"
$registryKey = "DisableHTTPPrinting"
$desiredValue = 1  # Disable HTTP printing

# Check if the registry path exists, and create it if it doesn't
if (-not (Test-Path $registryPath)) {
    Write-Host "Registry path $registryPath does not exist. Creating the path..."
    New-Item -Path $registryPath -Force | Out-Null
    Write-Host "Registry path created."
}

# Check if the registry value exists
$currentValue = Get-ItemProperty -Path $registryPath -Name $registryKey -ErrorAction SilentlyContinue

if ($currentValue -eq $null -or $currentValue.DisableHTTPPrinting -ne $desiredValue) {
    # The value doesn't exist or it's set to a value different from the desired one
    Write-Host "Configuring the registry value DisableHTTPPrinting to $desiredValue..."
    Set-ItemProperty -Path $registryPath -Name $registryKey -Value $desiredValue
    Write-Host "Registry value DisableHTTPPrinting set to $desiredValue."
} else {
    Write-Host "Registry value DisableHTTPPrinting is already correctly configured."
}

# Check if the policy "Turn off printing over HTTP" is enabled in Group Policy
$gpoKeyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
$gpoPolicyValueName = "DisableHTTPPrintingPolicy"
$gpoDesiredValue = 1  # 1 means "Enabled"

# Check if the policy exists and is set to "Enabled"
$currentGpoValue = Get-ItemProperty -Path $gpoKeyPath -Name $gpoPolicyValueName -ErrorAction SilentlyContinue

if ($currentGpoValue -eq $null -or $currentGpoValue.DisableHTTPPrintingPolicy -ne $gpoDesiredValue) {
    # The policy doesn't exist or it's not enabled
    Write-Host "Configuring the policy 'Turn off printing over HTTP' to 'Enabled'..."
    Set-ItemProperty -Path $gpoKeyPath -Name $gpoPolicyValueName -Value $gpoDesiredValue
    Write-Host "Policy 'Turn off printing over HTTP' set to 'Enabled'."
} else {
    Write-Host "Policy 'Turn off printing over HTTP' is already set to 'Enabled'."
}
