#Meeting Room Build Script

#region AutoLogin
# Automatic Login of Public user after imaging
$registryLocation = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
Set-ItemProperty -Path $registryLocation -Name "DefaultUserName" -Value "LibraryPublicUser"
Set-ItemProperty -Path $registryLocation -Name "AutoAdminLogon" -Value "1" -Type String
Set-ItemProperty -Path $registryLocation -Name "DefaultPassword" -Value "dits-pub-dwsp"
Set-ItemProperty -Path $registryLocation -Name "DefaultDomainName" -Value "LOCAL"
#Set-ItemProperty -Path $registryLocation -Name "ForceAutoLogon" -Value "1" -Type String
Remove-ItemProperty -Path $registryLocation -Name "AutoLogonCount" -Force
#endregion AutoLogin

#region Accounts
Set-LocalUser -Name "LUAdmin" -PasswordNeverExpires 1
Set-LocalUser -Name "LibraryPublicUser" -PasswordNeverExpires 1
#endregion Accounts

#region ActivateOffice
# Activating Office over the internet with key it was installed with
# This should remove the need for IT to choose the activate over internet > Next option at startup while thawed
cscript.exe "C:\Program Files\Microsoft Office\Office16\ospp.vbs" /act
#endregion ActivateOffice

#region ImportCertificates
# Download files to local machine
Invoke-WebRequest "https://devon.imil.uk/adverts/test/Fortinet_CA_SSL(3).cer" -OutFile "C:\Windows\Temp\Fortinet_CA_SSL(3).cer"

$certFile3 = "C:\Windows\Temp\Fortinet_CA_SSL(3).cer"
$certStoreLocation = "Cert:\LocalMachine\Root"

# Import Certificate(3)
Import-Certificate -FilePath $certFile3 -CertStoreLocation $certStoreLocation

# Clean up temp files
Remove-Item -Path "C:\Windows\Temp\Fortinet_CA_SSL(3).cer" -Force
#endregion ImportCertificates

# Set Power Management for NIC
$registryLocation = "HKLM:\System\CurrentControlSet\Control\Power"
Set-ItemProperty -Path $registryLocation -Name "PlatformAoAcOverride" -Value 0 -Type DWord

# Set Power Settings for default power profile
powercfg.exe /X monitor-timeout-ac 0
powercfg.exe /X monitor-timeout-dc 0
powercfg.exe /X disk-timeout-ac 0
powercfg.exe /X disk-timeout-dc 0
powercfg.exe /X standby-timeout-ac 0
powercfg.exe /X standby-timeout-dc 0
powercfg.exe /X hibernate-timeout-ac 0
powercfg.exe /X hibernate-timeout-dc 0

# Disable OneDrive
$registryLocation = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive"
if(-not(Test-Path $registryLocation)){
	New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\" -Name "OneDrive"
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Value 1 -Type DWord

# Remove Recently Added Apps from Start Menu
$registryLocation = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
if(-not(Test-Path $registryLocation)){
	New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\" -Name "Explorer"
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "HideRecentlyAddedApps" -Value 1 -Type DWord

# Disable Device Management warning
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" -Name "Enabled" -Value "0"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" -Name "EnabledBootId" -Value "0"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" -Name "WasEnabledBy" -Value "0"



