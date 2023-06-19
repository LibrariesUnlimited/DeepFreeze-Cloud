# TEST - testing a script directly from GitHub.com instead of from Insight server

if(-not(Test-Path "C:\GitHubTemp\")) {
	New-Item "C:\GitHubTemp\" -ItemType Directory -Force
}

Invoke-WebRequest "https://devon.imil.uk/adverts/test/teraterm-4.106.exe" -OutFile "C:\GitHubTemp\teraterm-4.106.exe"