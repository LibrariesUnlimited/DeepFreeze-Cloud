#Imaging script to set Public User account to automatically log on after maintenance.
Start-Transcript "C:\Program Files\Libraries Unlimited\autologontranscript.txt"

Write-Host "Is Frozen?"
& "C:\Windows\SysWOW64\DFC.exe" get /isfrozen
Write-Host "Version?"
& "C:\Windows\SysWOW64\DFC.exe" get /version
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

Stop-Transcript

$path = "C:\Program Files\Libraries Unlimited"

$script = @'
$debugLog = "C:\Program Files\Libraries Unlimited\autologonstartup.log"
$registryLocation = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
Write-Output "Starting script at $(Get-Date -Format "dd-MM-yyyy HH:mm:ss")..." | Out-File -FilePath $debugLog -Append
Get-ItemProperty -Path $registryLocation | Out-File -FilePath $debugLog -Append
Write-Output "Ending script at $(Get-Date -Format "dd-MM-yyyy HH:mm:ss")..." | Out-File -FilePath $debugLog -Append
Write-Output "---------------------------------------------------------" | Out-File -FilePath $debugLog -Append
'@

# Set Permissions for Libraries Unlimited directory as Full Control for everyone for launchurl.bat tweaks during startup
$InheritanceFlag = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [System.Security.AccessControl.InheritanceFlags]::ObjectInherit
$PropagationFlag = [System.Security.AccessControl.PropagationFlags]::None
$fileACL = Get-ACL -Path $path -EA SilentlyContinue
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Users","FullControl",$InheritanceFlag,$PropagationFlag,"Allow")
$fileACL.SetAccessRule($accessRule)
$fileACL | Set-ACL -Path $path

$script | Out-File -FilePath "$path\AutoLog.ps1" -Encoding ascii

$trigger = New-ScheduledTaskTrigger -AtStartup
$user = "$env:computername\LUTestUser"
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File ""$path\AutoLog.ps1"""

Register-ScheduledTask -TaskName "LU Auto Startup" -User $user -Trigger $trigger -Action $action