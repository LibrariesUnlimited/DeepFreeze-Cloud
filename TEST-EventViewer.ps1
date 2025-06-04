# TEST - Event Viewer Logs location
$logFile = "C:\Program Files\Libraries Unlimited\eventviewer.log"

# Transcript Logging
Start-Transcript $logFile
Write-Output "Logging to $logFile"
Write-Output "###### START $(Get-Date -Format "dd-MM-yyyy HH:mm:ss") ##### "

Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog"

# Expected Locations
#$application = "C:\Windows\EventLogs\Application.evtx"
#$hardwareEvents = "C:\Windows\EventLogs\HardwareEvents.evtx"
#$security = "C:\Windows\EventLogs\Security.evtx"
#$system = "C:\Windows\EventLogs\System.evtx"

# PhaseOneTest Test Locations
# Expected Locations
$application = "C:\windows\system32\winevt\Logs\Application.evtx"
$hardwareEvents = "C:\windows\system32\winevt\Logs\HardwareEvents.evtx"
$security = "C:\windows\system32\winevt\Logs\Security.evtx"
$system = "C:\windows\system32\winevt\Logs\System.evtx"

# Application check and change
$registryLocation = "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Application"
if ((Get-ItemProperty -Path $registryLocation -Name "File")."File" -ne $application) {
    Set-ItemProperty -Path $registryLocation -Name "File" -Type ExpandString -Value $application -Force
    Set-ItemProperty -Path $registryLocation -Name "Flags" -Type DWord -Value 1 -Force
    Write-Output "Application Eventlog Incorrect"
    Write-Output "---------------------"
}

Stop-Transcript