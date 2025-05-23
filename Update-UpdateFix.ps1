#Script to fix post Windows Update problems that have occurred, needs to run every logon just to be sure.

$logFile = "C:\Program Files\Libraries Unlimited\updatefix.log"

# Transcript Logging
Start-Transcript $logFile
Write-Output "Logging to $logFile"
Write-Output "###### START $(Get-Date -Format "dd-MM-yyyy HH:mm:ss") ##### "

$path = "C:\Windows\System32\spool\PRINTERS"

# Set Permissions for %windir%\system32\spool\PRINTERS as Modify for BUILTIN\Users for printing to work
$InheritanceFlag = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [System.Security.AccessControl.InheritanceFlags]::ObjectInherit
$PropagationFlag = [System.Security.AccessControl.PropagationFlags]::None
$fileACL = Get-ACL -Path $path -EA SilentlyContinue
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Users","Modify",$InheritanceFlag,$PropagationFlag,"Allow")
$fileACL.SetAccessRule($accessRule)
$fileACL | Set-ACL -Path $path

# Set Power Management for NIC
$registryLocation = "HKLM:\System\CurrentControlSet\Control\Power"
Set-ItemProperty -Path $registryLocation -Name "PlatformAoAcOverride" -Value 0 -Type DWord

Write-Output "###### END $(get-date) #####"
Stop-Transcript