$registryLocation = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$null = New-ItemProperty -Name "DefaultUserName" -Path $registryLocation -PropertyType string -Value "LUTestUser" -Force -EA Stop
$null = New-ItemProperty -Name "AutoAdminLogon" -Path $registryLocation -PropertyType string -Value "1" -Force -EA Stop
$null = New-ItemProperty -Name "DefaultPassword" -Path $registryLocation -PropertyType string -Value "FaronicsTest45!" -Force -EA Stop

