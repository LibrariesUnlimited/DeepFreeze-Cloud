#This script is a Failure, it was a logon script which was downloaded by the CreateLogonScript.ps1 script which did not work.  

Start-Transcript -path "C:\Windows\Temp\ProxyLogon.Log"

$logfile = "C:\LogonScriptRunning.log"

write-output "Script Running" | out-file -filepath $logfile -append

$registrylocation = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
$null = New-ItemProperty -Name "ProxyEnable" -Path $registryLocation -PropertyType DWord -Value "1" -Force -EA Stop
$null = New-ItemProperty -Name "ProxyServer" -Path $registryLocation -PropertyType string -Value "172.18.20.9" -Force -EA Stop

Stop-Transcript