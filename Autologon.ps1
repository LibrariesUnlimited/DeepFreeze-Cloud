#Imaging script to set Public User account to automatically log on after maintenance.

$registryLocation = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
Set-ItemProperty -Path $registryLocation -Name "DefaultUserName" -Value "LUTestUser"
Set-ItemProperty -Path $registryLocation -Name "AutoAdminLogon" -Value "1" -Type String
Set-ItemProperty -Path $registryLocation -Name "DefaultPassword" -Value "FaronicsTest45"
Set-ItemProperty -Path $registryLocation -Name "ForceAutoLogon" -Value "1" -Type String
