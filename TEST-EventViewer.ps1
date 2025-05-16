# TEST - Event Viewer Logs location
$logFile = "C:\Program Files\Libraries Unlimited\eventviewer.log"

# Transcript Logging
Start-Transcript $logFile
Write-Output "Logging to $logFile"
Write-Output "###### START $(Get-Date -Format "dd-MM-yyyy HH:mm:ss") ##### "

Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog"

Stop-Transcript