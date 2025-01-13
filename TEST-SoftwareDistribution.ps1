# TEST Script to clear SoftwareDistribution folder which is stopping updates.
# Download file names are too long for Powershell to remove so need to use RoboCopy for this one folder

$logFile = "C:\Windows\Temp\softwaredistribution_$(Get-Date -Format "dd-MM-yyyy_HH-mm-ss").log"
$logPath = "C:\Windows\Temp"

# Transcript Logging
Start-Transcript $logFile
Write-Output "Logging to $logFile"
Write-Output "###### START $(Get-Date -Format "dd-MM-yyyy HH:mm:ss") ##### "

try {
    Write-Verbose 'Stopping Windows Update & Background Intelligent Transfer services...'
    Get-Service -Name 'wuauserv', 'bits' | Stop-Service
}
catch {
    Write-Warning $_
}
try {
    Write-Verbose 'Clearing SoftwareDistribution\Download folder...'
    # Create (temporary) empty folder
    New-Item -ItemType Directory -Path ".\Empty" -ErrorAction SilentlyContinue
    # Mirror the empty directory to the folder to delete; this will effectively empty the folder.
    robocopy /MIR ".\Empty" "$env:SystemRoot\SoftwareDistribution\Download" /njh /njs /ndl /nc /ns /np /nfl #>nul 2>&1
    # Delete the folder now that it's empty
    Remove-Item "$env:SystemRoot\SoftwareDistribution\Download" -Force
    # Delete our temporary empty folder
    Remove-Item ".\Empty" -Force
}
catch {
    Write-Error $_
}

#Then remove all the other folders
Write-Verbose 'Clearing SoftwareDistribution folder...'
Remove-Item -Path "$env:SystemRoot\SoftwareDistribution\*" -Force -Verbose -Confirm:$false -Recurse -ErrorAction 'Continue' -WarningAction 'Continue'

try {
    Write-Verbose 'Starting Windows Update & Background Intelligent Transfer services...'
    Get-Service -Name 'wuauserv', 'bits' | Start-Service
}
catch {
    Write-Warning $_
}

Write-Output "###### END $(get-date) #####"
Stop-Transcript