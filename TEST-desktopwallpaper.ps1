# TEST - desktopwallpaper
$logFile = "C:\Program Files\Libraries Unlimited\wallpaper.log"

# Transcript Logging
Start-Transcript $logFile
Write-Output "Logging to $logFile"
Write-Output "###### START $(Get-Date -Format "dd-MM-yyyy HH:mm:ss") ##### "

# Changing desktop wallpaper from Windows default of "Spotlight" to a plain blue background for childrens login stuff

$Data = @{
    WallpaperURL              = "https://devon.imil.uk/adverts/test/background.jpg" # Change to your fitting
    RegKeyPath                = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP' # Assigns the wallpaper
    StatusValue               = "1"
}

# Downloads the image file from the source location
Invoke-WebRequest $Data.WallpaperURL -OutFile "C:\Program Files\Libraries Unlimited\background.jpg"

New-Item -Path $Data.RegKeyPath -Force -ErrorAction SilentlyContinue | Out-Null
Set-ItemProperty -Path $Data.RegKeyPath -Name 'DesktopImageStatus' -Value $Data.Statusvalue -Type DWord
#New-ItemProperty -Path $Data.RegKeyPath -Name 'DesktopImageStatus' -Value $Data.Statusvalue -PropertyType DWORD -Force | Out-Null
Set-ItemProperty -Path $Data.RegKeyPath -Name 'DesktopImagePath' -Value "C:\Program Files\Libraries Unlimited\background.jpg" -Type String 
#New-ItemProperty -Path $Data.RegKeyPath -Name 'DesktopImagePath' -Value "C:\Program Files\Libraries Unlimited\background.jpg" -PropertyType STRING -Force | Out-Null
#New-ItemProperty -Path $Data.RegKeyPath -Name 'DesktopImageUrl' -Value $WallpaperDest -PropertyType STRING -Force | Out-Null

Stop-Transcript