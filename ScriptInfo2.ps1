$logfile = "C:\Windows\temp\scriptingtest2_$(Get-Date -Format "dd-MM-yyyy").log"

Write-Output "Starting script at $(Get-Date -Format "dd-MM-yyyy HH:mm:ss")..." | Out-File -FilePath $logfile -Append

if(Test-Path -Path "C:\TeraTermTemp\teraterm-4.106.exe" -PathType Leaf) {
	#CopyFileFromWeb.ps1 "Download Web" script run
    Write-Output "$(Get-Date -Format "dd-MM-yyyy HH:mm:ss"): Download Web Script has been run" | Out-File -FilePath $logfile -Append
} Else {
    Write-Output "$(Get-Date -Format "dd-MM-yyyy HH:mm:ss"): Download Web Script has NOT been run" | Out-File -FilePath $logfile -Append
}

if(Test-Path -Path "C:\Program Files (x86)\Foxit Software\Foxit PDF Reader") {
	#Foxit Reader installed
    Write-Output "$(Get-Date -Format "dd-MM-yyyy HH:mm:ss"): Foxit PDF Reader has been installed" | Out-File -FilePath $logfile -Append
} Else {
    Write-Output "$(Get-Date -Format "dd-MM-yyyy HH:mm:ss"): Foxit PDF Reader has NOT been installed" | Out-File -FilePath $logfile -Append
}

if(Test-Path -Path "C:\Program Files (x86)\teraterm") {
	#teraterm installed
    Write-Output "$(Get-Date -Format "dd-MM-yyyy HH:mm:ss"): TeraTerm has been installed" | Out-File -FilePath $logfile -Append
} Else {
    Write-Output "$(Get-Date -Format "dd-MM-yyyy HH:mm:ss"): TeraTerm has NOT been installed" | Out-File -FilePath $logfile -Append
}

Write-Output "$(Get-Date -Format "dd-MM-yyyy HH:mm:ss"): Log Files Created" | Out-File -FilePath $logfile -Append
Get-Item "C:\Windows\temp\scriptingtest*.log" | Out-File -FilePath $logfile -Append

Write-Output "Stopping script at $(Get-Date -Format "dd-MM-yyyy HH:mm:ss")..." | Out-File -FilePath $logfile -Append