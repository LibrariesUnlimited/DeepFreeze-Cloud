#Successful script for Imaging a computer, the methodology required is because the build process will need to be completed on a network with DHCP which would not have the Proxy
#this means the Admin account should not have proxy settings but the PublicUser account should so I couldn't use a "Computer Wide" proxy setting

#This script creates a logon script ($script variable is content of powershell script) which is set as a Logon Scheduled Task for the publicuser account (which can be done when the user doesn't exist yet)
#This will change settings so a neater version would then delete the scheduled task when completed ... that part is untested

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