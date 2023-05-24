Start-Transcript -Path $(Join-Path $env:TEMP "TestSMBImage.log")
Write-Output "Transcript Started"

if(-not(Test-Path "C:\TestSMBImage\")){
	New-Item "C:\TestSMBImage\" -ItemType Directory -Force
	Write-Output "Directory Created"
}

Invoke-WebRequest "https://devon.imil.uk/adverts/test/teraterm-4.106.exe" -OutFile "C:\TestSMBImage\SMB.exe"

if(-not(Test-Path "HKLM:\Software\Microsoft\Office\ClickToRun\REGISTRY\MACHINE\Software\Wow6432Node\Insight Media")){
	New-Item -Path "HKLM:\Software\Microsoft\Office\ClickToRun\REGISTRY\MACHINE\Software\Wow6432Node\" -Name "Insight Media"
	New-Item -Path "HKLM:\Software\Microsoft\Office\ClickToRun\REGISTRY\MACHINE\Software\Wow6432Node\Insight Media" -Name "iCAM Central Reports"
	Write-Output "Full Registry Created"
}
if(-not(Test-Path "HKLM:\Software\Microsoft\Office\ClickToRun\REGISTRY\MACHINE\Software\Wow6432Node\Insight Media\iCAM Central Reports")){
	New-Item -Path "HKLM:\Software\Microsoft\Office\ClickToRun\REGISTRY\MACHINE\Software\Wow6432Node\Insight Media" -Name "iCAM Central Reports"
	Write-Output "Database Registry Created"
}
if(-not(Test-Path "HKLM:\Software\Microsoft\Office\ClickToRun\REGISTRY\MACHINE\Software\Insight Media")){
	New-Item -Path "HKLM:\Software\Microsoft\Office\ClickToRun\REGISTRY\MACHINE\Software\" -Name "Insight Media"
	New-Item -Path "HKLM:\Software\Microsoft\Office\ClickToRun\REGISTRY\MACHINE\Software\Insight Media" -Name "iCAM Central Reports"
	Write-Output "Full Registry Created"
}
if(-not(Test-Path "HKLM:\Software\Microsoft\Office\ClickToRun\REGISTRY\MACHINE\Software\Insight Media\iCAM Central Reports")){
	New-Item -Path "HKLM:\Software\Microsoft\Office\ClickToRun\REGISTRY\MACHINE\Software\Insight Media" -Name "iCAM Central Reports"
	Write-Output "Database Registry Created"
}
$registryLocation = "HKLM:\Software\Microsoft\Office\ClickToRun\REGISTRY\MACHINE\Software\Wow6432Node\Insight Media\iCAM Central Reports"
$null = New-ItemProperty -Name "database" -Path $registryLocation -PropertyType string -Value "icam" -Force -EA Stop
$null = New-ItemProperty -Name "DSN" -Path $registryLocation -PropertyType string -Value "" -Force -EA Stop
$null = New-ItemProperty -Name "ismysql" -Path $registryLocation -PropertyType string -Value "False" -Force -EA Stop
$null = New-ItemProperty -Name "port" -Path $registryLocation -PropertyType string -Value "14336" -Force -EA Stop
$null = New-ItemProperty -Name "pwd" -Path $registryLocation -PropertyType string -Value "Bl3ss3d!" -Force -EA Stop
$null = New-ItemProperty -Name "server" -Path $registryLocation -PropertyType string -Value "193.114.66.82" -Force -EA Stop
$null = New-ItemProperty -Name "uid" -Path $registryLocation -PropertyType string -Value "icam_ro" -Force -EA Stop
$registryLocation = "HKLM:\Software\Microsoft\Office\ClickToRun\REGISTRY\MACHINE\Software\Insight Media\iCAM Central Reports"
$null = New-ItemProperty -Name "database" -Path $registryLocation -PropertyType string -Value "icam" -Force -EA Stop
$null = New-ItemProperty -Name "DSN" -Path $registryLocation -PropertyType string -Value "" -Force -EA Stop
$null = New-ItemProperty -Name "ismysql" -Path $registryLocation -PropertyType string -Value "False" -Force -EA Stop
$null = New-ItemProperty -Name "port" -Path $registryLocation -PropertyType string -Value "14336" -Force -EA Stop
$null = New-ItemProperty -Name "pwd" -Path $registryLocation -PropertyType string -Value "Bl3ss3d!" -Force -EA Stop
$null = New-ItemProperty -Name "server" -Path $registryLocation -PropertyType string -Value "193.114.66.82" -Force -EA Stop
$null = New-ItemProperty -Name "uid" -Path $registryLocation -PropertyType string -Value "icam_ro" -Force -EA Stop
Write-Output "Created Registry Items"

$acl = get-acl 'HKLM:\Software\Microsoft\Office\ClickToRun'
$idRef = [System.Security.Principal.NTAccount]("BUILTIN\Users")
$regRights = [System.Security.AccessControl.RegistryRights]::FullControl
$inhFlags = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit
$prFlags = [System.Security.AccessControl.PropagationFlags]::None
$acType = [System.Security.AccessControl.AccessControlType]::Allow
$rule = New-Object System.Security.AccessControl.RegistryAccessRule ($idRef, $regRights, $inhFlags, $prFlags, $acType)
$acl.AddAccessRule($rule)
$acl | Set-Acl -Path 'HKLM:\Software\Microsoft\Office\ClickToRun'
Write-Output "Set Registry Permissions"
Stop-Transcript