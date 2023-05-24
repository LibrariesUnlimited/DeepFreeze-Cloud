
$script = @'
$logfile = "C:\Windows\Temp\LogonScript.log"

Write-Output "Script Running" | Out-File -FilePath $logfile -Append

$registryLocation = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
$null = New-ItemProperty -Name "ProxyEnable" -Path $registryLocation -PropertyType DWord -Value "1" -Force -EA Stop
$null = New-ItemProperty -Name "ProxyServer" -Path $registryLocation -PropertyType string -Value "172.18.20.9:8080" -Force -EA Stop

Write-Output "Script Finished" | Out-File -FilePath $logfile -Append
'@

$path = "C:\Program Files\Libraries Unlimited"

if(-not(Test-Path $path)) {
    New-Item -path $path -itemType Directory
}

$script | Out-File -FilePath "$path\ProxyStartup.ps1" -Encoding ascii

$trigger = New-ScheduledTaskTrigger -AtLogOn -User "$env:computername\LUTestUser"
$user = "$env:computername\LUTestUser"
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File ""$path\ProxyStartup.ps1"""

Register-ScheduledTask -TaskName "Proxy Startup" -User $user -Trigger $trigger -Action $action