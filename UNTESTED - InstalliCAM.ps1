# Script to download and install iCAM Workstation Client and Print Client in order
# Not installing UltraViewer as it is installed from DeepFreeze so not needed

#still test download location

if(-not(Test-Path "C:\InstallTemp\")) {
	New-Item "C:\InstallTemp\" -ItemType Directory -Force
}

Invoke-WebRequest "https://devon.imil.uk/adverts/test/iCAM Workstation Control Client 5.9.1.msi" -OutFile "C:\InstallTemp\iCAM Workstation Control Client 5.9.1.msi"

Invoke-WebRequest "https://devon.imil.uk/adverts/test/iCAM Print Client 4.7.0.1000.msi" -OutFile "C:\InstallTemp\iCAM Print Client 4.7.0.1000.msi"

# Start-Process -Wait means the MSIExec.exe task will be required to finished before moving on to the next line of the Powershell Script
#need to test quotes work
Start-Process msiexec.exe -Wait -ArgumentList '/i "C:\InstallTemp\iCAM Workstation Control Client 5.9.1.msi" ADDLOCAL=iCAMWorkstationControlClient,Services,iCAMSCR,KeyboardFilter /qn /norestart'

#need to test driver installs correctly as well
Start-Process msiexec.exe -Wait -ArgumentList '/i "C:\InstallTemp\iCAM Print Client 4.7.0.1000.msi" /qn /norestart'

# Clean up downloaded files
Remove-Item -Path "C:\InstallTemp" -Recurse -Force