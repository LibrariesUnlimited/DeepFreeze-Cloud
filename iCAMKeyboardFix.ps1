
#Start of Real Script

$logFile = "C:\Windows\Temp\icamkeyboardfix_$(Get-Date -Format "dd-MM-yyyy_HH-mm-ss").log"
$logPath = "C:\Windows\Temp"

# Transcript Logging
Start-Transcript $logFile
Write-Output "Logging to $logFile"
Write-Output "###### START $(Get-Date -Format "dd-MM-yyyy HH:mm:ss") ##### "


# Checking to see if script has already completed
if(-not(Test-Path -Path "C:\Program Files (x86)\iCAM\keyboardfixcomplete.txt" -PathType Leaf)) {
	#run all the script

    # Download File
    Invoke-WebRequest "https://devon.imil.uk/adverts/test/iCAM Workstation Control Client 5.9.1.msi" -OutFile "C:\Program Files (x86)\iCAM\iCAM Workstation Control Client 5.9.1.msi"
    $file = "C:\Program Files (x86)\iCAM\iCAM Workstation Control Client 5.9.1.msi"

    # Checking to see if script has already uninstalled
    if(-not(Test-Path -Path "C:\Program Files (x86)\iCAM\keyboardfixrunning.txt" -PathType Leaf)) {
        #This is where the script will uninstall iCAM

        #region uninstalliCAM
        Write-Output "$(Get-Date -Format "dd-MM-yyyy HH:mm:ss"): Uninstall iCAM"
        Write-Output "$(Get-Date -Format "dd-MM-yyyy HH:mm:ss"): File Created as about to uninstall iCAM" | Out-File -FilePath "C:\Program Files (x86)\iCAM\keyboardfixrunning.txt" -Append

        $arguments = "/x ""$file"" /qn /norestart /l*V ""$logpath\icamuninstall.log"
        Start-Process -FilePath "msiexec.exe" -ArgumentList $arguments -Wait

        Write-Output "$(Get-Date -Format "dd-MM-yyyy HH:mm:ss"): Finished uninstall iCAM, there should not be a reboot here"
        #endregion

    } Else {
        Write-Output "$(Get-Date -Format "dd-MM-yyyy HH:mm:ss"): Keyboard Fix Script has already uninstalled iCAM" 
        #iCAM doesn't need to be uninstalled so will just go onto the next step of reinstalling it
    }

    #region reinstalliCAM
    Write-Output "$(Get-Date -Format "dd-MM-yyyy HH:mm:ss"): Reinstall iCAM"
    Write-Output "$(Get-Date -Format "dd-MM-yyyy HH:mm:ss"): File Created as about to reinstall iCAM" | Out-File -FilePath "C:\Program Files (x86)\iCAM\keyboardfixcomplete.txt" -Append

    $arguments = "/i ""$file"" ADDLOCAL=iCAMWorkstationControlClient,Services,iCAMSCR,KeyboardFilter /qn /l*V ""$logpath\icamreinstall.log"
    Start-Process -FilePath "msiexec.exe" -ArgumentList $arguments -Wait

    Write-Output "$(Get-Date -Format "dd-MM-yyyy HH:mm:ss"): Finished Reinstall iCAM so maybe rebooting"
    #endregion

} Else {
    Write-Output "$(Get-Date -Format "dd-MM-yyyy HH:mm:ss"): Keyboard Fix Script has already completed" 
    #This will be the end of the script
}

Write-Output "###### END $(get-date) #####"
Stop-Transcript