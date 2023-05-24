if(-not(Test-Path "C:\TeraTermTemp\")) {
	New-Item "C:\TeraTermTemp\" -ItemType Directory -Force
}

Invoke-WebRequest "https://devon.imil.uk/adverts/test/teraterm-4.106.exe" -OutFile "C:\TeraTermTemp\teraterm-4.106.exe"