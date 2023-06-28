#Imaging script to set Public User account to automatically log on after maintenance.
Start-Transcript "C:\Program Files\Libraries Unlimited\autologontranscript.txt"

& "C:\Windows\SysWOW64\DFC.exe" get /isfrozen
$registryLocation = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"

#debugging
$debugLog = "C:\Program Files\Libraries Unlimited\autologondebug.log"

Write-Output "Starting script at $(Get-Date -Format "dd-MM-yyyy HH:mm:ss")..." | Out-File -FilePath $debugLog -Append
Get-ItemProperty -Path $registryLocation | Out-File -FilePath $debugLog -Append

Write-Output "Changing Registry Settings" | Out-File -FilePath $debugLog -Append
Write-Output "---------------------------------------------------------" | Out-File -FilePath $debugLog -Append

Set-ItemProperty -Path $registryLocation -Name "LastUsedUsername" -Value "LUTestUser"
Set-ItemProperty -Path $registryLocation -Name "DefaultUserName" -Value "LUTestUser"
Set-ItemProperty -Path $registryLocation -Name "AutoAdminLogon" -Value "1" -Type String
Set-ItemProperty -Path $registryLocation -Name "DefaultPassword" -Value "FaronicsTest45!"
Set-ItemProperty -Path $registryLocation -Name "ForceAutoLogon" -Value "1" -Type String


Write-Output "Registry Settings Changed" | Out-File -FilePath $debugLog -Append
Write-Output "---------------------------------------------------------" | Out-File -FilePath $debugLog -Append

Get-ItemProperty -Path $registryLocation | Out-File -FilePath $debugLog -Append
Write-Output "Ending script at $(Get-Date -Format "dd-MM-yyyy HH:mm:ss")..." | Out-File -FilePath $debugLog -Append
Write-Output "---------------------------------------------------------" | Out-File -FilePath $debugLog -Append