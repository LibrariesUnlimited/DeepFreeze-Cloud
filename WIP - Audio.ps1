# Does not work as permissions aren't correct even though I can do it from RegEdit ... makes no sense

Start-Transcript -Path "C:\Program Files\Libraries Unlimited\AudioTranscript.txt"
Write-Output "Transcript Started"

$registryLocation = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render\"
$audio = Get-ChildItem -Path $registryLocation | ForEach-Object {Get-ItemProperty -Path $_.PsPath | Where-Object {$_.DeviceState -eq 1} | Select-Object PSChildName }

$derivedRegistryLocation = $registryLocation + $audio.PSChildName

Set-ItemProperty -Path $derivedRegistryLocation -Name "DeviceState" -Value 268435457 -Type DWord

Stop-Transcript