Start-Transcript -Path "C:\Windows\Temp\CreateLogonScript.log"

$User = Get-LocalUser -Name LUTestUser | Select SID

$path = "$ENV:systemRoot\System32\GroupPolicy\User\Scripts"
$logonpath = "$ENV:systemRoot\System32\GroupPolicy\User\Scripts\Logon"
if(-not(Test-Path $path)) {
	New-Item -path $path -itemType Directory
	New-Item -path $logonpath -itemType Directory
}

Invoke-WebRequest "https://devon.imil.uk/adverts/test/ProxyLogon.ps1" -OutFile "$logonpath\ProxyLogon.ps1"

$regkey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\$($User.SID)\Scripts\Logon\0"
$regkey0 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\$($User.SID)\Scripts\Logon\0\0"

New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\$($User.SID)" -Name "Scripts"
New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\$($User.SID)\Scripts" -Name "Logon"
New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\$($User.SID)\Scripts\Logon" -Name "0"
New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\$($User.SID)\Scripts\Logon\0" -Name "0"


$null = New-ItemProperty -path $regkey -name DisplayName -propertyType String -value "Local Group Policy" 
$null = New-ItemProperty -path $regkey -name FileSysPath -propertyType String -value "$ENV:systemRoot\System32\GroupPolicy\User" 
$null = New-ItemProperty -path $regkey -name GPO-ID -propertyType String -value "LocalGPO"
$null = New-ItemProperty -path $regkey -name GPOName -propertyType String -value "Local Group Policy"
$null = New-ItemProperty -path $regkey -name PSScriptOrder -propertyType DWord -value 1 
$null = New-ItemProperty -path $regkey -name SOM-ID -propertyType String -value "Local"

$null = New-ItemProperty -path $regkey0 -name Script -propertyType String -value 'ProxyLogon.ps1'
$null = New-ItemProperty -path $regkey0 -name Parameters -propertyType String -value ''
#$null = New-ItemProperty -path $regkey0 -name ExecTime -propertyType QWord -value 0

"`r`n[Logon]`r`n0CmdLine=ProxyLogon.ps1`r`n0Parameters=`r`n" | out-file -FilePath "$ENV:systemRoot\System32\GroupPolicy\User\Scripts\psscripts.ini"

Stop-Transcript