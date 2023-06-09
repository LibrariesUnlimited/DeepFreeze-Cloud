# Script to download and install iCAM Workstation Client and Print Client in order
# Not installing UltraViewer as it is installed from DeepFreeze so not needed

if(-not(Test-Path "C:\Program Files (x86)\iCAM\")) {
	New-Item "C:\Program Files (x86)\iCAM\" -ItemType Directory -Force
}

Invoke-WebRequest "https://devon.imil.uk/adverts/test/iCAM Workstation Control Client 5.9.1.msi" -OutFile "C:\Program Files (x86)\iCAM\iCAM Workstation Control Client 5.9.1.msi"

Invoke-WebRequest "https://devon.imil.uk/adverts/test/iCAM Print Client 4.7.0.1000.msi" -OutFile "C:\Program Files (x86)\iCAM\iCAM Print Client 4.7.0.1000.msi"

# Start-Process -Wait means the MSIExec.exe task will be required to finished before moving on to the next line of the Powershell Script
Start-Process msiexec.exe -Wait -ArgumentList '/i "C:\Program Files (x86)\iCAM\iCAM Workstation Control Client 5.9.1.msi" ADDLOCAL=iCAMWorkstationControlClient,Services,iCAMSCR,KeyboardFilter /qn /norestart'


Start-Process msiexec.exe -Wait -ArgumentList '/i "C:\Program Files (x86)\iCAM\iCAM Print Client 4.7.0.1000.msi" /qn /norestart'

#Notes : Workstation Control Client did not show up in Add/Remove Programs after first test, trying leaving the install files on the computer this time to see if it works.
#Installer did work however