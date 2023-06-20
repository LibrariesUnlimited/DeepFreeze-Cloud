# TEST - testing a script directly from GitHub.com instead of from Insight server

if(-not(Test-Path "C:\GitHubTemp\")) {
	New-Item "C:\GitHubTemp\" -ItemType Directory -Force
}

Invoke-WebRequest "https://devon.imil.uk/adverts/test/teraterm-4.106.exe" -OutFile "C:\GitHubTemp\teraterm-4.106.exe"

Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" -Name "Enabled" -Value "0"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" -Name "EnabledBootId" -Value "0"
# this last one is the important one but for some reason it was set to 1 when first testing.
# will try again after some other rebuild tests.
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" -Name "WasEnabledBy" -Value "0"