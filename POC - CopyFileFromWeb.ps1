#This file is a Proof of Concept to show downloading of a file from the internet to local machine


if(-not(Test-Path "C:\TeraTermTemp\")) {
	New-Item "C:\TeraTermTemp\" -ItemType Directory -Force
}

Invoke-WebRequest "https://devon.imil.uk/adverts/test/teraterm-4.106.exe" -OutFile "C:\TeraTermTemp\teraterm-4.106.exe"