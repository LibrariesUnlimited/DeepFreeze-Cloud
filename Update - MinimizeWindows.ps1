# Update - HKCU Login Script to disable "Minimize windows when a monitor is disconnected" option to stop iCAM being hidden when someone turns off the monitor

$script = @'

# Disable "Minimize windows when a monitor is disconnected" option to stop iCAM being hidden when someone turns off the monitor
Set-ItemProperty -Name "MonitorRemovalRecalcBehavior" -Path "HKCU:\Control Panel\Desktop" -Type DWord -Value "0"

'@

$path = "C:\Program Files\Libraries Unlimited"

$script | Out-File -FilePath "$path\MinimizeWindows.ps1" -Encoding ascii

$trigger = New-ScheduledTaskTrigger -AtLogOn -User "$env:computername\LibraryPublicUser"
$user = "$env:computername\LibraryPublicUser"
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File ""$path\MinimizeWindows.ps1"""

Register-ScheduledTask -TaskName "LU MinimizeWindows" -User $user -Trigger $trigger -Action $action