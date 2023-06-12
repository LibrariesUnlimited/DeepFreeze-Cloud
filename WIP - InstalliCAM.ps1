# Script to download and install iCAM Workstation Client and Print Client in order
# Not installing UltraViewer as it is installed from DeepFreeze so not needed

#still test download location

if(-not(Test-Path "C:\Program Files (x86)\iCAM\")) {
	New-Item "C:\Program Files (x86)\iCAM\" -ItemType Directory -Force
}

Invoke-WebRequest "https://devon.imil.uk/adverts/test/iCAM Workstation Control Client 5.9.1.msi" -OutFile "C:\Program Files (x86)\iCAM\iCAM Workstation Control Client 5.9.1.msi"
Invoke-WebRequest "https://devon.imil.uk/adverts/test/iCAM Print Client 4.7.0.1000.msi" -OutFile "C:\Program Files (x86)\iCAM\iCAM Print Client 4.7.0.1000.msi"

# Start-Process -Wait means the MSIExec.exe task will be required to finished before moving on to the next line of the Powershell Script
#need to test quotes work
#Start-Process msiexec.exe -Wait -ArgumentList '/i "C:\Program Files (x86)\iCAM\iCAM Workstation Control Client 5.9.1.msi" ADDLOCAL=iCAMWorkstationControlClient,Services,iCAMSCR,KeyboardFilter /qn /norestart'

$msiFile = "C:\Program Files (x86)\iCAM\iCAM Workstation Control Client 5.9.1.msi"
$logFile = "C:\Program Files (x86)\iCAM\msi_install_log.txt"

$arguments = "/i ""$msiFile"" ADDLOCAL=iCAMWorkstationControlClient,Services,iCAMSCR,KeyboardFilter /qn /norestart /log ""$logFile"""
$processStartInfo = New-Object System.Diagnostics.ProcessStartInfo
$processStartInfo.FileName = "msiexec.exe"
$processStartInfo.Arguments = $arguments
$processStartInfo.RedirectStandardOutput = $true
$processStartInfo.RedirectStandardError = $true
$processStartInfo.UseShellExecute = $false
$processStartInfo.CreateNoWindow = $true

$process = New-Object System.Diagnostics.Process
$process.StartInfo = $processStartInfo

$process.Start() | Out-Null
$process.WaitForExit()

$exitCode = $process.ExitCode

Write-Output "$(Get-Date -Format "dd-MM-yyyy HH:mm:ss"): $($exitCode)" | Out-File -FilePath "C:\Program Files (x86)\iCAM\msi_error_log.txt" -Append
$exitCode | Out-File -FilePath "C:\Program Files (x86)\iCAM\msi_error_log.txt" -Append

$msiFile = "C:\Program Files (x86)\iCAM\iCAM Print Client 4.7.0.1000.msi"
$logFile = "C:\Program Files (x86)\iCAM\msi_print_install_log.txt"

$arguments = "/i ""$msiFile"" /qn /norestart /log ""$logFile"""
$processStartInfo = New-Object System.Diagnostics.ProcessStartInfo
$processStartInfo.FileName = "msiexec.exe"
$processStartInfo.Arguments = $arguments
$processStartInfo.RedirectStandardOutput = $true
$processStartInfo.RedirectStandardError = $true
$processStartInfo.UseShellExecute = $false
$processStartInfo.CreateNoWindow = $true

$process = New-Object System.Diagnostics.Process
$process.StartInfo = $processStartInfo

$process.Start() | Out-Null
$process.WaitForExit()

$exitCode = $process.ExitCode

Write-Output "$(Get-Date -Format "dd-MM-yyyy HH:mm:ss"): $($exitCode)" | Out-File -FilePath "C:\Program Files (x86)\iCAM\msi_print_error_log.txt" -Append
$exitCode | Out-File -FilePath "C:\Program Files (x86)\iCAM\msi_print_error_log.txt" -Append


