#Script to fix post Windows Update problems that have occurred, needs to run every logon just to be sure.
$path = "C:\Windows\System32\spool\PRINTERS"

# Set Permissions for Libraries Unlimited directory as Full Control for everyone for launchurl.bat tweaks during startup
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