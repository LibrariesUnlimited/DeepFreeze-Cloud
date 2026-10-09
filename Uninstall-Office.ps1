$logFile = "C:\Program Files\Libraries Unlimited\Uninstall-Office.log"
Start-Transcript $logFile
Write-Output "Logging to $logFile"
Write-Output "###### START $(get-date) ##### "

if(-not(Test-Path -Path "C:\Program Files\Libraries Unlimited\UninstallOffice.txt" -PathType Leaf)) {
    if(-not(Test-Path -Path "C:\Program Files\Libraries Unlimited\Office\" -PathType Container)) {
        New-Item -ItemType Directory -Path "C:\Program Files\Libraries Unlimited\Office\"
    }
    New-Item -ItemType Directory -Path "C:\Program Files\Libraries Unlimited\Office2\"
    #Download File
    Invoke-WebRequest "https://devon.imil.uk/adverts/test/Office/Uninstall.zip" -OutFile "C:\Program Files\Libraries Unlimited\Office\Uninstall.zip"
    #Extract Zip Files
    Expand-Archive -Path "C:\Program Files\Libraries Unlimited\Office\Uninstall.zip" -DestinationPath "C:\Program Files\Libraries Unlimited\Office\"

    . "C:\Program Files\Libraries Unlimited\Office\Setup.exe" /configure "C:\Program Files\Libraries Unlimited\Office\Uninstall.xml"
    
    
    
    
    
    
    
    
    
    #Write-Output "$(Get-Date -Format "dd-MM-yyyy HH:mm:ss"): Office Uninstalled" | Out-File -FilePath "C:\Program Files\Libraries Unlimited\UninstallOffice.txt" -Append
}

Stop-Transcript