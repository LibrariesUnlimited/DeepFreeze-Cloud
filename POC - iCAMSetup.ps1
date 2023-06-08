# Script for setting Admin PC IP Address on Workstation and Print Client
# May try and create a CASE to get the correct info from the computer name so only a single script ... To be decided

if(-not(Test-Path "HKLM:\Software\Insight Media\Cafe Client")){
	New-Item -Path "HKLM:\Software\Insight Media\" -Name "Cafe Client"
}
if(-not(Test-Path "HKLM:\Software\Insight Media\Print Client")){
	New-Item -Path "HKLM:\Software\Insight Media\" -Name "Print Client"
}

$registryPath = "HKLM:\SOFTWARE\Insight Media\Print Client"

# Set the registry values
Set-ItemProperty -Path $registryPath -Name "Server IP" -Value "10.10.10.10"
Set-ItemProperty -Path $registryPath -Name "Server Port" -Value "1457"
Set-ItemProperty -Path $registryPath -Name "Server Password" -Value "90!80%'<;!"
Set-ItemProperty -Path $registryPath -Name "Connection Delay" -Value 1 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Connection Timeout" -Value 20 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Config Retry Delay" -Value 10 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Keep Alive Interval" -Value 60 -Type DWord
Set-ItemProperty -Path $registryPath -Name "DHCP" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Multi User System Support Enabled" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Thin Client" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Terminal Server IP" -Value ""
Set-ItemProperty -Path $registryPath -Name "Temporary Folder" -Value "C:\ProgramData\iCAM\PC\"
Set-ItemProperty -Path $registryPath -Name "Zip Print Jobs" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Visuals Enabled" -Value 1 -Type DWord

$registryPath = "HKLM:\SOFTWARE\Insight Media\Cafe Client"

# Set the registry values
Set-ItemProperty -Path $registryPath -Name "Server Address" -Value "10.10.10.10"
Set-ItemProperty -Path $registryPath -Name "iCAM Port" -Value 1456 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Force Reg Read For Primary Server" -Value 1 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Client Initialisation Delay Seconds" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Thin Client" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "DHCP Client" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Advert Initialisation File" -Value "10.10.10.10"
Set-ItemProperty -Path $registryPath -Name "Terms and Conditions" -Value ""
Set-ItemProperty -Path $registryPath -Name "Application Data Path" -Value "C:\ProgramData\iCAM\WC\"
Set-ItemProperty -Path $registryPath -Name "Adverts Environment Profile" -Value ""
Set-ItemProperty -Path $registryPath -Name "Show Exit Button Delay" -Value 60 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Require Exit Password" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Exit Password" -Value "90!80: !"
Set-ItemProperty -Path $registryPath -Name "Windows Default Username" -Value ""
Set-ItemProperty -Path $registryPath -Name "Windows Default Password" -Value ""
Set-ItemProperty -Path $registryPath -Name "Windows Default Domain" -Value ""
Set-ItemProperty -Path $registryPath -Name "Windows Log Off" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Hide Windows Details On Successful Login" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Always Perform Windows Logoff" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Auto Switch Servers" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Server Switch Require Password" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Server Switch Password" -Value ""
Set-ItemProperty -Path $registryPath -Name "Switch Server Display Delay" -Value 120 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Clean Folder" -Value ""
Set-ItemProperty -Path $registryPath -Name "Clean Folder Keep Sub Folders" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Run on Close" -Value ""
Set-ItemProperty -Path $registryPath -Name "Run On Session End" -Value ""
Set-ItemProperty -Path $registryPath -Name "Log In Box Title" -Value "Please enter your identification information."
Set-ItemProperty -Path $registryPath -Name "ID Required Text" -Value "Member Number"
Set-ItemProperty -Path $registryPath -Name "PIN Prompt Text" -Value "PIN"
Set-ItemProperty -Path $registryPath -Name "Windows Password Change Text" -Value "[Changed] Your session cannot start until you change your password.`n`nWould you like to change it now? Note, selecting <No> will end your session."
Set-ItemProperty -Path $registryPath -Name "Windows Password Expired Text" -Value "[Expired] Your session cannot start until you change your password.`n`nWould you like to change it now? Note, selecting <No> will end your session."
Set-ItemProperty -Path $registryPath -Name "Windows Account Disabled Text" -Value "Your session cannot start because your Window's account has been disabled.`n`nPlease see your System Administrator."
Set-ItemProperty -Path $registryPath -Name "Windows Account Expired Text" -Value "Your session cannot start because your Window's account has expired.`n`nPlease see your System Administrator."
Set-ItemProperty -Path $registryPath -Name "Out Of Order Notification Enabled" -Value 1 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Out Of Order Notification Delay Secs" -Value 120 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Out Of Order Notification Text" -Value "Out Of Order.`n`nPlease use a different workstation or see a member of staff for assistance.`n`nWe apologize for the inconvenience."
Set-ItemProperty -Path $registryPath -Name "Close VNC" -Value 1 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Enable Application Focus Agent" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Focus Agent Timer Interval" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Hide On Screen IP Address" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Pause Adverts When Login Visible" -Value "-1"
Set-ItemProperty -Path $registryPath -Name "Show Shutdown On Login Box" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Login Box Shutdown Button Caption" -Value "Shutdown"
Set-ItemProperty -Path $registryPath -Name "LDAP Server Address" -Value ""
Set-ItemProperty -Path $registryPath -Name "Virtual Desktop Monitor Enabled" -Value "0"
Set-ItemProperty -Path $registryPath -Name "Bold Launcher Tabs" -Value 0 -Type DWord