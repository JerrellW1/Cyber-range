<#
.SYNOPSIS
    This PowerShell script ensures that Passwords must not be saved in the Remote Desktop Client.
    
    Author          : Jerrell Williams
    GitHub          : github.com/JerrellW1
    Date Created    : 2025-03-17
    Last Modified   : 2025-03-17
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000270

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\STIG-ID-WN10-CC-000270.ps1 
#>

# Define the registry path and value for DisablePasswordSaving
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
$regName = "DisablePasswordSaving"
$regValue = 1  # 1 = Disabled, 0 = Enabled

# Check if the registry path exists
if (Test-Path $regPath) {
    # Set the value for DisablePasswordSaving if it's not already set
    Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Force
    Write-Host "Successfully disabled password saving in Remote Desktop."
} else {
    Write-Host "Registry path does not exist. Creating the path and setting the value."
    # Create the path and set the value
    New-Item -Path $regPath -Force | Out-Null
    Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Force
    Write-Host "Successfully created the registry key and disabled password saving in Remote Desktop."
}

# Force Group Policy Update
gpupdate /force

Write-Host "Password saving has been disabled for Remote Desktop Connection. Please restart the system for the policy to take full effect."
