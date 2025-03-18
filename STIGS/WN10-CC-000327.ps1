<#
.SYNOPSIS
    This PowerShell script ensures that PowerShell Transcription is enabled on Windows 10.

    Author          : Jerrell Williams
    GitHub          : github.com/JerrellW1
    Date Created    : 2025-03-17
    Last Modified   : 2025-03-17
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000327

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\STIG-ID-WN10-CC-000327.ps1 
#>

# Define the registry path and value for PowerShell Transcription
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription"
$regName = "EnableTranscripting"
$regValue = 1  # 1 = Enabled, 0 = Disabled

# Check if the registry path exists
if (Test-Path $regPath) {
    # Set the value for EnableTranscripting if it's not already set
    Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Force
    Write-Host "Successfully enabled PowerShell transcription."
} else {
    Write-Host "Registry path does not exist. Creating the path and setting the value."
    # Create the path and set the value
    New-Item -Path $regPath -Force | Out-Null
    Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Force
    Write-Host "Successfully created the registry key and enabled PowerShell transcription."
}

# Specify the transcript output directory path (for example, a secure central log server location)
$transcriptDirectory = "C:\SecureTranscripts"  # Change this path to your secure log server or central location

# Ensure the specified directory exists, and create it if necessary
if (-Not (Test-Path $transcriptDirectory)) {
    New-Item -Path $transcriptDirectory -ItemType Directory -Force
    Write-Host "Created the transcript directory at $transcriptDirectory."
} else {
    Write-Host "Transcript directory already exists at $transcriptDirectory."
}

# Set the registry value for specifying the output directory
$regTranscriptPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription"
$regTranscriptName = "OutputDirectory"
$regTranscriptValue = $transcriptDirectory

# Set the output directory registry value
Set-ItemProperty -Path $regTranscriptPath -Name $regTranscriptName -Value $regTranscriptValue -Force
Write-Host "Successfully configured the transcript output directory to $transcriptDirectory."

# Force Group Policy Update
gpupdate /force

Write-Host "PowerShell Transcription has been enabled, and the transcript output directory has been configured. Please restart the system for the policy to take full effect."
