<#
.SYNOPSIS
    This PowerShell script ensures that Internet connection sharing is disabled.

.NOTES
    Author          : Jerrell Williams
    GitHub          : github.com/JerrellW1
    Date Created    : 2025-03-16
    Last Modified   : 2025-03-16
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000044

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\STIG-ID-WN10-CC-000044.ps1 
#>

# Define the registry path, value name, and desired value
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Network Connections"
$registryKey = "NC_ShowSharedAccessUI"
$desiredValue = 0x00000000  # 0 in hexadecimal (Disabling Shared Access UI)

# Check if the registry path exists, and create it if it doesn't
if (-not (Test-Path $registryPath)) {
    Write-Host "Registry path $registryPath does not exist. Creating the path..."
    New-Item -Path $registryPath -Force | Out-Null
    Write-Host "Registry path created."
}

# Check if the registry value exists
$currentValue = Get-ItemProperty -Path $registryPath -Name $registryKey -ErrorAction SilentlyContinue

if ($currentValue -eq $null -or $currentValue.NC_ShowSharedAccessUI -ne $desiredValue) {
    # The value doesn't exist or it's set to a value different from the desired one
    Write-Host "Configuring the registry value NC_ShowSharedAccessUI to $desiredValue..."
    Set-ItemProperty -Path $registryPath -Name $registryKey -Value $desiredValue
    Write-Host "Registry value NC_ShowSharedAccessUI set to $desiredValue."
} else {
    Write-Host "Registry value NC_ShowSharedAccessUI is already correctly configured."
}

# Check if the policy "Prohibit use of Internet Connection Sharing on your DNS domain network" is enabled
$gpoKeyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Network Connections"
$gpoPolicyValueName = "ProhibitInternetConnectionSharing"
$gpoDesiredValue = 1  # 1 means "Enabled"

# Check if the policy exists and is set to "Enabled"
$currentGpoValue = Get-ItemProperty -Path $gpoKeyPath -Name $gpoPolicyValueName -ErrorAction SilentlyContinue

if ($currentGpoValue -eq $null -or $currentGpoValue.ProhibitInternetConnectionSharing -ne $gpoDesiredValue) {
    # The policy doesn't exist or it's not enabled
    Write-Host "Configuring the policy 'Prohibit use of Internet Connection Sharing' to 'Enabled'..."
    Set-ItemProperty -Path $gpoKeyPath -Name $gpoPolicyValueName -Value $gpoDesiredValue
    Write-Host "Policy 'Prohibit use of Internet Connection Sharing' set to 'Enabled'."
} else {
    Write-Host "Policy 'Prohibit use of Internet Connection Sharing' is already set to 'Enabled'."
}
