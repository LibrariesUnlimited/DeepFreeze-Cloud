#uninstall OCR software


$logFile = "C:\Program Files\Libraries Unlimited\scannerfix.log"


# Transcript Logging
Start-Transcript $logFile
Write-Output "Logging to $logFile"
Write-Output "###### START $(Get-Date -Format "dd-MM-yyyy HH:mm:ss") ##### "

$arguments = "/X{3615C893-F844-4A5B-B949-8409EAB62271}"
Start-Process -FilePath "msiexec.exe" -ArgumentList $arguments -Wait

Stop-Transcript