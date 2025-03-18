<#
.SYNOPSIS
    This PowerShell script ensures that Reversible password encryption is disabled.

    Author          : Jerrell Williams
    GitHub          : github.com/JerrellW1
    Date Created    : 2025-03-17
    Last Modified   : 2025-03-17
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AC-000045

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\STIG-ID-WN10-AC-000045.ps1 
#>

# Check if the value exists, and set it to disable the reversible encryption
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"
$regName = "DisablePasswordCaching"
$regValue = 1

# Check if the registry path exists
if (Test-Path $regPath) {
    # Set the value to "1" to disable reversible encryption
    Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Force
    Write-Host "Successfully disabled password reversible encryption."
} else {
    Write-Host "Registry path does not exist. Creating the path and setting the value."
    # Create the path and set the value
    New-Item -Path $regPath -Force | Out-Null
    Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Force
    Write-Host "Successfully created the registry key and disabled password reversible encryption."
}

# Force Group Policy Update
gpupdate /force

Write-Host "Password reversible encryption policy has been disabled. Please restart the system for the policy to take full effect."
