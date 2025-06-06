<# 
Live Build Script for Public PCs
Script to be a single script which runs in order rather than multiple scripts which all run at the same time and require extra folder validation
#>

<#
Still to do/check:
 
#>


#region AutoLogin
# Automatic Login of Public user after imaging
$registryLocation = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
Set-ItemProperty -Path $registryLocation -Name "DefaultUserName" -Value "LibraryPublicUser"
Set-ItemProperty -Path $registryLocation -Name "AutoAdminLogon" -Value "1" -Type String
Set-ItemProperty -Path $registryLocation -Name "DefaultPassword" -Value "dits-pub-dwsp"
Set-ItemProperty -Path $registryLocation -Name "DefaultDomainName" -Value "LOCAL"
#Set-ItemProperty -Path $registryLocation -Name "ForceAutoLogon" -Value "1" -Type String
Remove-ItemProperty -Path $registryLocation -Name "AutoLogonCount" -Force
#endregion AutoLogin

#region Accounts
Set-LocalUser -Name "LUAdmin" -PasswordNeverExpires 1
Set-LocalUser -Name "LibraryPublicUser" -PasswordNeverExpires 1
#endregion Accounts

#region ActivateOffice
# Activating Office over the internet with key it was installed with
# This should remove the need for IT to choose the activate over internet > Next option at startup while thawed
cscript.exe "C:\Program Files\Microsoft Office\Office16\ospp.vbs" /act
#endregion ActivateOffice

#region ConfigureiCAMSettings
# checking Registry Keys are in place
if(-not(Test-Path "HKLM:\SOFTWARE\Insight Media\")){
    New-Item -Path "HKLM:\SOFTWARE\" -Name "Insight Media"
	New-Item -Path "HKLM:\SOFTWARE\Insight Media\" -Name "Cafe Client"
	New-Item -Path "HKLM:\SOFTWARE\Insight Media\" -Name "Print Client"
    New-Item -Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\" -Name "Monitor"
}
if(-not(Test-Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\")){
	New-Item -Path "HKLM:\SOFTWARE\Insight Media\" -Name "Cafe Client"
    New-Item -Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\" -Name "Monitor"
}
if(-not(Test-Path "HKLM:\SOFTWARE\Insight Media\Print Client\")){
	New-Item -Path "HKLM:\SOFTWARE\Insight Media\" -Name "Print Client"
}
if(-not(Test-Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\Monitor\")){
    New-Item -Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\" -Name "Monitor"
}

# Registry key/values for iCAM autorun
$autorunValues = @{
    "iCAMClient"="C:\Program Files (x86)\iCAM\Workstation Control\icamclient.exe"
    "iCAMPrint"="C:\Program Files (X86)\iCAM\printer Control\prntray.exe"
}
$autorunPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"

$autorunValues.GetEnumerator() | ForEach-Object {
    Set-ItemProperty -Path $autorunPath -Name $_.Key -Value $_.Value
}

$registryPath = "HKLM:\SOFTWARE\Insight Media\Cafe Client"

# Set the workstation client registry values
Set-ItemProperty -Path $registryPath -Name "iCAM Port" -Value 1456 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Force Reg Read For Primary Server" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Client Initialisation Delay Seconds" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Thin Client" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "DHCP Client" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Advert Initialisation File" -Value "https://devon.imil.uk/adverts/adverts2021.ini"
Set-ItemProperty -Path $registryPath -Name "Terms and Conditions" -Value "https://devon.imil.uk/adverts/terms.htm"
Set-ItemProperty -Path $registryPath -Name "Application Data Path" -Value "C:\ProgramData\iCAM\WC\"
Set-ItemProperty -Path $registryPath -Name "Adverts Environment Profile" -Value "Adverts"
Set-ItemProperty -Path $registryPath -Name "Show Exit Button Delay" -Value 60 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Require Exit Password" -Value 1 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Exit Password" -Value "!='ff79t;18t60"
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
Set-ItemProperty -Path $registryPath -Name "Log In Box Title" -Value "Please enter your Ticket Number or ..."
Set-ItemProperty -Path $registryPath -Name "ID Required Text" -Value "Library Card No"
Set-ItemProperty -Path $registryPath -Name "PIN Prompt Text" -Value "PIN"
Set-ItemProperty -Path $registryPath -Name "Windows Password Change Text" -Value "[Changed] Your session cannot start until you change your password.`n`nWould you like to change it now? Note, selecting <No> will end your session."
Set-ItemProperty -Path $registryPath -Name "Windows Password Expired Text" -Value "[Expired] Your session cannot start until you change your password.`n`nWould you like to change it now? Note, selecting <No> will end your session."
Set-ItemProperty -Path $registryPath -Name "Windows Account Disabled Text" -Value "Your session cannot start because your Window's account has been disabled.`n`nPlease see your System Administrator."
Set-ItemProperty -Path $registryPath -Name "Windows Account Expired Text" -Value "Your session cannot start because your Window's account has expired.`n`nPlease see your System Administrator."
Set-ItemProperty -Path $registryPath -Name "Out Of Order Notification Enabled" -Value 1 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Out Of Order Notification Delay Secs" -Value 120 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Out Of Order Notification Text" -Value "Out Of Order.`n`nPlease use a different workstation or see a member of staff for assistance.`n`nWe apologize for the inconvenience."
Set-ItemProperty -Path $registryPath -Name "Close VNC" -Value 1 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Enable Application Focus Agent" -Value 1 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Focus Agent Timer Interval" -Value 320 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Hide On Screen IP Address" -Value 1 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Pause Adverts When Login Visible" -Value "0" -Type String
Set-ItemProperty -Path $registryPath -Name "Show Shutdown On Login Box" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Login Box Shutdown Button Caption" -Value "Shutdown"
Set-ItemProperty -Path $registryPath -Name "LDAP Server Address" -Value ""
Set-ItemProperty -Path $registryPath -Name "Virtual Desktop Monitor Enabled" -Value "-1" -Type String
Set-ItemProperty -Path $registryPath -Name "Bold Launcher Tabs" -Value 0 -Type DWord

$registryPath = "HKLM:\SOFTWARE\Insight Media\Print Client"

# Set the print client registry values
Set-ItemProperty -Path $registryPath -Name "Server Port" -Value "1457"
Set-ItemProperty -Path $registryPath -Name "Server Password" -Value "&6:!!"
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

# Create Monitor Settings
$registryPath = "HKLM:\SOFTWARE\Insight Media\Cafe Client\Monitor"

Set-ItemProperty -Path $registryPath -Name "Monitor Users" -Value "LUAdmin"
Set-ItemProperty -Path $registryPath -Name "Monitor Force LogOff" -Value 1 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Monitor User Category" -Value 2 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Monitor Interval" -Value 60 -Type DWord

#endregion ConfigureiCAMSettings

#region CreateiCAMProfiles
# Create Environment Profiles
New-Item -Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\" -Name "Environment Profiles"
New-Item -Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\Environment Profiles\" -Name "LU User"
$registryPath = "HKLM:\SOFTWARE\Insight Media\Cafe Client\Environment Profiles\LU User"
Set-ItemProperty -Path $registryPath -Name "Disable Alt Escape" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Disable Alt F4" -Value 1 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Disable Alt Return" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Disable Alt Tab" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Disable Application Key" -Value 1 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Disable Ctrl Alt Del" -Value 1 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Disable Ctrl Esc" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Disable Desktop" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Disable Start Button" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Disable Taskbar" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Disable System Tray" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Disable Quick Launch" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Disable Windows Keys" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Disable Mouse Right Click" -Value 0 -Type DWord

New-Item -Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\Environment Profiles\" -Name "LU Child User"
$registryPath = "HKLM:\SOFTWARE\Insight Media\Cafe Client\Environment Profiles\LU Child User"
Set-ItemProperty -Path $registryPath -Name "Disable Alt Escape" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Disable Alt F4" -Value 1 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Disable Alt Return" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Disable Alt Tab" -Value 0 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Disable Application Key" -Value 1 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Disable Ctrl Alt Del" -Value 1 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Disable Ctrl Esc" -Value 1 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Disable Desktop" -Value 1 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Disable Start Button" -Value 1 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Disable Taskbar" -Value 1 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Disable System Tray" -Value 1 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Disable Quick Launch" -Value 1 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Disable Windows Keys" -Value 1 -Type DWord
Set-ItemProperty -Path $registryPath -Name "Disable Mouse Right Click" -Value 0 -Type DWord

# List of Profiles, remember if a profile is added here it needs to be added to the switch statement below
$profiles = @('ADC','ADU','CHC','CHI','Default','OOH','STC','STU')

# Registry key/values for Adult Profiles
$adultValues = @{
    "Use Proxy Server" = 1
    "Proxy Server Port" = 8080
    "Proxy Server Host" = "172.18.20.81"
    "Terms and Conditions" = ""
    "Run on Unlock" = ""
    "Desktop Wallpaper" = "C:\Program Files (x86)\iCAM\Workstation Control\newdesktop1920x1032.jpg"
    "Environment Profile" = "LU User"
    "RunMinimised" = 0
    "RunTaskBarOnly" = 0
    "Allow Windows Shutdown" = 0
    "Run Full Screen" = 1
    "HideMissingApps" = 1
    "Allow Extend Request" = 0
    "Allow Session Pause" = 1
    "Allow Help Request" = 0
    "Allow Request Help" = 0
    "Shortcut Font Name" = "Arial Narrow"
    "Shortcut Font Size" = 12
    "Shortcut Font Colour" = 16777215
    "Shortcut Font Style" = "fsBold"
    "Timer Position Left" = 10
    "Timer Position Top" = 8
    "Pause Session Postion Left" = 8
    "Pause Session Postion Top" = 129
    "End Session Position Left" = 8
    "End Session Position Top" = 55
    "Request Time Postion Left" = 8
    "Request Time Postion Right" = 64
    "Background Colour" = 2147483663
    "Request Help Position Left" = 8
    "Request Help Position Top" = 128
    "End Session Caption" = "END SESSION"
    "End Session Width" = 210
    "End Session Height" = 72
    "Pause Session Caption" = "Pause"
    "Pause Session Width" = 121
    "Pause Session Height" = 36
    "Request Time Caption" = "Request More Time"
    "Request Time Width" = 121
    "Request Time Height" = 24
    "Request Help Caption" = "Request Help"
    "Request Help Height" = 24
    "Request Help Width" = 121
    "End Session Font Size" = 18
    "Pause Session Font Size" = 8
    "Request Time Font Size" = 8
    "Request Help Font Size" = 8
    "Embedded Web Browser Visible" = 0
    "Embedded Web Browser XPos" = 476
    "Embedded Web Browser YPos" = 211
    "Embedded Web Browser Height" = 257
    "Embedded Web Browser Width" = 720
    "Embedded Web Browser URL" = "https://devon.imil.uk/adverts/test/EmbeddedAdvert700x227.jpg"
}

# Registry key/values for Adult Applications
# "Calculator"="c:\windows\system32\calc.exe,,,550,370,0"
$adultApplicationsValues = @{
    "Internet"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://www.google.co.uk,,130,295,2"
    "Email"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://discover.librariesunlimited.org.uk/webmail-services,C:\Program Files (x86)\iCAM\Workstation Control\CPL\email2.ico,280,295,2"
    "Borrow Box"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://devon.borrowbox.com,C:\Program Files (x86)\iCAM\Workstation Control\CPL\borrowbox.ico,542,248,1"
    "Theory Test Pro"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://libraries-unlimited-devon-torbay.theorytestpro.co.uk/students/new,C:\Program Files (x86)\iCAM\Workstation Control\CPL\theorytest.ico,542,358,1"
    "Ancestry"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://ancestrylibrary.proquest.com,C:\Program Files (x86)\iCAM\Workstation Control\CPL\ancestry.ico,677,248,1"    
    "Go Citizen"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://libraries-unlimited-devon-torbay.gocitizen.co.uk/students/new,C:\Program Files (x86)\iCAM\Workstation Control\CPL\gocitizen.ico,677,358,1"    
    "Word"="C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE,,,110,587,1"
    "Powerpoint"="C:\Program Files\Microsoft Office\root\Office16\POWERPNT.EXE,,,210,697,1"
    "Excel"="C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE,,,210,587,1"
    "Publisher"="C:\Program Files\Microsoft Office\root\Office16\MSPUB.EXE,,,110,697,1"
    "File Explorer"="C:\WINDOWS\explorer.exe,,C:\WINDOWS\explorer.exe,310,587,1"
    "Computer Help"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://discover.librariesunlimited.org.uk/computer-help,C:\Windows\HelpPane.exe,1658,520,2"
    "Accessibility"="C:\Windows\explorer.exe,shell:::{D555645E-D4F8-4c29-A827-D93C859C4F2A},C:\Program Files (x86)\iCAM\Workstation Control\CPL\Ease of Access.ico,1658,385,2"
    "Sound"="C:\Program Files (x86)\iCAM\Workstation Control\CPL\Sound.exe,,C:\Program Files (x86)\iCAM\Workstation Control\CPL\Sound.ico,1658,655,2"
    "VLC - Media Player"="C:\Program Files\VideoLAN\VLC\vlc.exe,,,542,587,1"
    "GIMP - Graphics"="C:\Program Files\GIMP 2\bin\gimp-2.10.exe,,,542,697,1"
    "Paint - Graphics"="C:\Users\LibraryPublicUser\AppData\Local\Microsoft\WindowsApps\Microsoft.Paint_8wekyb3d8bbwe\mspaint.exe,,C:\Program Files (x86)\iCAM\Workstation Control\CPL\mspaint.ico,677,697,1"
    "Audacity - Audio"="C:\Program Files\Audacity\audacity.exe,,,677,587,1"
    "Reference Resources"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://discover.librariesunlimited.org.uk/-/digital-library,C:\Program Files (x86)\iCAM\Workstation Control\CPL\Newspapers.ico,1072,587,1"
    "Catalogue Search"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://discover.librariesunlimited.org.uk/extended-search,C:\Program Files (x86)\iCAM\Workstation Control\CPL\Books.ico,937,587,1"
    "Events"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://discover.librariesunlimited.org.uk/whats-on,C:\Program Files (x86)\iCAM\Workstation Control\CPL\calendar2.ico,937,697,1"
    "Online Services"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://discover.librariesunlimited.org.uk/web-resources,C:\Program Files (x86)\iCAM\Workstation Control\CPL\Desktop.ico,1072,697,1"
    "Support Us"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://www.librariesunlimited.org.uk/support-us/,C:\Program Files (x86)\iCAM\Workstation Control\CPL\libraries.ico,1170,925,1"
}

# Registry key/values for Filtered Profiles
$filteredValues = @{
    "Use Proxy Server" = 1
    "Proxy Server Port" = 8080
    "Proxy Server Host" = "172.18.20.9"
    "Terms and Conditions" = ""
    "Run on Unlock" = ""
    "Desktop Wallpaper" = "C:\Program Files (x86)\iCAM\Workstation Control\newdesktop1920x1032.jpg"
    "Environment Profile" = "LU User"
    "RunMinimised" = 0
    "RunTaskBarOnly" = 0
    "Allow Windows Shutdown" = 0
    "Run Full Screen" = 1
    "HideMissingApps" = 1
    "Allow Extend Request" = 0
    "Allow Session Pause" = 1
    "Allow Help Request" = 0
    "Allow Request Help" = 0
    "Shortcut Font Name" = "Arial Narrow"
    "Shortcut Font Size" = 12
    "Shortcut Font Colour" = 16777215
    "Shortcut Font Style" = "fsBold"
    "Timer Position Left" = 10
    "Timer Position Top" = 8
    "Pause Session Postion Left" = 8
    "Pause Session Postion Top" = 129
    "End Session Position Left" = 8
    "End Session Position Top" = 55
    "Request Time Postion Left" = 8
    "Request Time Postion Right" = 64
    "Background Colour" = 2147483663
    "Request Help Position Left" = 8
    "Request Help Position Top" = 128
    "End Session Caption" = "END SESSION"
    "End Session Width" = 210
    "End Session Height" = 72
    "Pause Session Caption" = "Pause"
    "Pause Session Width" = 121
    "Pause Session Height" = 36
    "Request Time Caption" = "Request More Time"
    "Request Time Width" = 121
    "Request Time Height" = 24
    "Request Help Caption" = "Request Help"
    "Request Help Height" = 24
    "Request Help Width" = 121
    "End Session Font Size" = 18
    "Pause Session Font Size" = 8
    "Request Time Font Size" = 8
    "Request Help Font Size" = 8
    "Embedded Web Browser Visible" = 0
    "Embedded Web Browser XPos" = 476
    "Embedded Web Browser YPos" = 211
    "Embedded Web Browser Height" = 257
    "Embedded Web Browser Width" = 720
    "Embedded Web Browser URL" = ""
}

# Registry key/values for Filtered Applications (Currently the same as Adult)
$filteredApplicationsValues = @{
    "Internet"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://www.google.co.uk,,130,295,2"
    "Email"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://discover.librariesunlimited.org.uk/webmail-services,C:\Program Files (x86)\iCAM\Workstation Control\CPL\email2.ico,280,295,2"
    "Borrow Box"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://devon.borrowbox.com,C:\Program Files (x86)\iCAM\Workstation Control\CPL\borrowbox.ico,542,248,1"
    "Theory Test Pro"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://libraries-unlimited-devon-torbay.theorytestpro.co.uk/students/new,C:\Program Files (x86)\iCAM\Workstation Control\CPL\theorytest.ico,542,358,1"
    "Ancestry"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://ancestrylibrary.proquest.com,C:\Program Files (x86)\iCAM\Workstation Control\CPL\ancestry.ico,677,248,1"    
    "Go Citizen"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://libraries-unlimited-devon-torbay.gocitizen.co.uk/students/new,C:\Program Files (x86)\iCAM\Workstation Control\CPL\gocitizen.ico,677,358,1"    
    "Word"="C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE,,,110,587,1"
    "Powerpoint"="C:\Program Files\Microsoft Office\root\Office16\POWERPNT.EXE,,,210,697,1"
    "Excel"="C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE,,,210,587,1"
    "Publisher"="C:\Program Files\Microsoft Office\root\Office16\MSPUB.EXE,,,110,697,1"
    "File Explorer"="C:\WINDOWS\explorer.exe,,C:\WINDOWS\explorer.exe,310,587,1"
    "Computer Help"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://discover.librariesunlimited.org.uk/computer-help,C:\Windows\HelpPane.exe,1658,520,2"
    "Accessibility"="C:\Windows\explorer.exe,shell:::{D555645E-D4F8-4c29-A827-D93C859C4F2A},C:\Program Files (x86)\iCAM\Workstation Control\CPL\Ease of Access.ico,1658,385,2"
    "Sound"="C:\Program Files (x86)\iCAM\Workstation Control\CPL\Sound.exe,,C:\Program Files (x86)\iCAM\Workstation Control\CPL\Sound.ico,1658,655,2"
    "VLC - Media Player"="C:\Program Files\VideoLAN\VLC\vlc.exe,,,542,587,1"
    "GIMP - Graphics"="C:\Program Files\GIMP 2\bin\gimp-2.10.exe,,,542,697,1"
    "Paint - Graphics"="C:\Users\LibraryPublicUser\AppData\Local\Microsoft\WindowsApps\Microsoft.Paint_8wekyb3d8bbwe\mspaint.exe,,C:\Program Files (x86)\iCAM\Workstation Control\CPL\mspaint.ico,677,697,1"
    "Audacity - Audio"="C:\Program Files\Audacity\audacity.exe,,,677,587,1"
    "Reference Resources"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://discover.librariesunlimited.org.uk/-/digital-library,C:\Program Files (x86)\iCAM\Workstation Control\CPL\Newspapers.ico,1072,587,1"
    "Catalogue Search"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://discover.librariesunlimited.org.uk/extended-search,C:\Program Files (x86)\iCAM\Workstation Control\CPL\Books.ico,937,587,1"
    "Events"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://discover.librariesunlimited.org.uk/whats-on,C:\Program Files (x86)\iCAM\Workstation Control\CPL\calendar2.ico,937,697,1"
    "Online Services"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://discover.librariesunlimited.org.uk/web-resources,C:\Program Files (x86)\iCAM\Workstation Control\CPL\Desktop.ico,1072,697,1"
    "Support Us"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://www.librariesunlimited.org.uk/support-us/,C:\Program Files (x86)\iCAM\Workstation Control\CPL\libraries.ico,1170,925,1"
}

# Registry key/values for Child Profiles
# not changed yet to make text correct
$childValues = @{
    "Use Proxy Server" = 1
    "Proxy Server Port" = 8080
    "Proxy Server Host" = "172.18.20.9"
    "Terms and Conditions" = ""
    "Run on Unlock" = ""
    "Desktop Wallpaper" = "C:\Program Files (x86)\iCAM\Workstation Control\childdesktop1920x1032.jpg"
    "Environment Profile" = "LU Child User"
    "RunMinimised" = 0
    "RunTaskBarOnly" = 0
    "Allow Windows Shutdown" = 0
    "Run Full Screen" = 1
    "HideMissingApps" = 1
    "Allow Extend Request" = 0
    "Allow Session Pause" = 1
    "Allow Help Request" = 0
    "Allow Request Help" = 0
    "Shortcut Font Name" = "Arial Narrow"
    "Shortcut Font Size" = 12
    "Shortcut Font Colour" = 16777215
    "Shortcut Font Style" = "fsBold"
    "Timer Position Left" = 10
    "Timer Position Top" = 8
    "Pause Session Postion Left" = 8
    "Pause Session Postion Top" = 129
    "End Session Position Left" = 8
    "End Session Position Top" = 55
    "Request Time Postion Left" = 8
    "Request Time Postion Right" = 64
    "Background Colour" = 2147483663
    "Request Help Position Left" = 8
    "Request Help Position Top" = 128
    "End Session Caption" = "END SESSION"
    "End Session Width" = 210
    "End Session Height" = 72
    "Pause Session Caption" = "Pause"
    "Pause Session Width" = 121
    "Pause Session Height" = 36
    "Request Time Caption" = "Request More Time"
    "Request Time Width" = 121
    "Request Time Height" = 24
    "Request Help Caption" = "Request Help"
    "Request Help Height" = 24
    "Request Help Width" = 121
    "End Session Font Size" = 18
    "Pause Session Font Size" = 8
    "Request Time Font Size" = 8
    "Request Help Font Size" = 8
    "Embedded Web Browser Visible" = 0
    "Embedded Web Browser XPos" = 0
    "Embedded Web Browser YPos" = 0
    "Embedded Web Browser Height" = 100
    "Embedded Web Browser Width" = 100
    "Embedded Web Browser URL" = ""
}

# Registry key/values for Child Applications
#"Calculator"="c:\windows\system32\calc.exe,,,550,370,0"
$childApplicationsValues = @{
    "Word"="C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE,,,110,248,1"
    "Powerpoint"="C:\Program Files\Microsoft Office\root\Office16\POWERPNT.EXE,,,210,358,1"
    "Excel"="C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE,,,210,248,1"
    "Publisher"="C:\Program Files\Microsoft Office\root\Office16\MSPUB.EXE,,,110,358,1"
    "File Explorer"="C:\WINDOWS\explorer.exe,,C:\WINDOWS\explorer.exe,310,248,1"
    "Accessibility"="C:\Windows\explorer.exe,shell:::{D555645E-D4F8-4c29-A827-D93C859C4F2A},C:\Program Files (x86)\iCAM\Workstation Control\CPL\Ease of Access.ico,1658,385,2"
    "Sound"="C:\Program Files (x86)\iCAM\Workstation Control\CPL\Sound.exe,,C:\Program Files (x86)\iCAM\Workstation Control\CPL\Sound.ico,1658,655,2"
    "VLC - Media Player"="C:\Program Files\VideoLAN\VLC\vlc.exe,,,140,587,1"
    "GIMP - Graphics"="C:\Program Files\GIMP 2\bin\gimp-2.10.exe,,,140,697,1"
    "Paint - Graphics"="C:\Users\LibraryPublicUser\AppData\Local\Microsoft\WindowsApps\Microsoft.Paint_8wekyb3d8bbwe\mspaint.exe,,C:\Program Files (x86)\iCAM\Workstation Control\CPL\mspaint.ico,275,697,1"
    "Audacity - Audio"="C:\Program Files\Audacity\audacity.exe,,,275,587,1"
}

# check for Application Launcher registry key and create if missing
if(-not(Test-Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\Application Launcher\")){
	New-Item -Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\" -Name "Application Launcher"
}

#  ADC and ADU and Default and OOH the same (all adult), CHC and CHI the same (all child), STC and STU the same (child filter) 
switch ( $profiles ) {
    {($_ -eq "ADC") -or ($_ -eq "ADU") -or ($_ -eq "Default") -or ($_ -eq "OOH")} 
        {
            if(-not(Test-Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\Application Launcher\$_")){
                New-Item -Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\Application Launcher\" -Name $_
                New-Item -Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\Application Launcher\$_\" -Name "Applications"
            }

            $profileName = $_
            $adultValues.GetEnumerator() | ForEach-Object {
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\Application Launcher\$profileName" -Name $_.Key -Value $_.Value
            }

            $adultApplicationsValues.GetEnumerator() | ForEach-Object {
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\Application Launcher\$profileName\Applications" -Name $_.Key -Value $_.Value
            }
        }
    {($_ -eq "CHC") -or ($_ -eq "CHI")} 
        {
            if(-not(Test-Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\Application Launcher\$_")){
                New-Item -Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\Application Launcher\" -Name $_
                New-Item -Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\Application Launcher\$_\" -Name "Applications"
            }

            $profileName = $_
            $childValues.GetEnumerator() | ForEach-Object {
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\Application Launcher\$profileName" -Name $_.Key -Value $_.Value
            }

            $childApplicationsValues.GetEnumerator() | ForEach-Object {
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\Application Launcher\$profileName\Applications" -Name $_.Key -Value $_.Value
            }            
        }
    {($_ -eq "STC") -or ($_ -eq "STU")} 
        {
            if(-not(Test-Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\Application Launcher\$_")){
                New-Item -Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\Application Launcher\" -Name $_
                New-Item -Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\Application Launcher\$_\" -Name "Applications"
            }

            $profileName = $_
            $filteredValues.GetEnumerator() | ForEach-Object {
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\Application Launcher\$profileName" -Name $_.Key -Value $_.Value
            }

            $filteredApplicationsValues.GetEnumerator() | ForEach-Object {
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\Application Launcher\$profileName\Applications" -Name $_.Key -Value $_.Value
            }              
        }
}
#endregion CreateiCAMProfiles

#region ImportCertificates
# Download files to local machine
Invoke-WebRequest "https://devon.imil.uk/adverts/test/Fortinet_CA_SSL(1).cer" -OutFile "C:\Windows\Temp\Fortinet_CA_SSL(1).cer"
Invoke-WebRequest "https://devon.imil.uk/adverts/test/Fortinet_CA_SSL(2).cer" -OutFile "C:\Windows\Temp\Fortinet_CA_SSL(2).cer"
Invoke-WebRequest "https://devon.imil.uk/adverts/test/Fortinet_CA_SSL(3).cer" -OutFile "C:\Windows\Temp\Fortinet_CA_SSL(3).cer"

$certFile1 = "C:\Windows\Temp\Fortinet_CA_SSL(1).cer"
$certFile2 = "C:\Windows\Temp\Fortinet_CA_SSL(2).cer"
$certFile3 = "C:\Windows\Temp\Fortinet_CA_SSL(3).cer"
$certStoreLocation = "Cert:\LocalMachine\Root"

# Import Certificate(1)
Import-Certificate -FilePath $certFile1 -CertStoreLocation $certStoreLocation
# Import Certificate(2)
Import-Certificate -FilePath $certFile2 -CertStoreLocation $certStoreLocation
# Import Certificate(3)
Import-Certificate -FilePath $certFile3 -CertStoreLocation $certStoreLocation

# Clean up temp files
Remove-Item -Path "C:\Windows\Temp\Fortinet_CA_SSL(1).cer" -Force
Remove-Item -Path "C:\Windows\Temp\Fortinet_CA_SSL(2).cer" -Force
Remove-Item -Path "C:\Windows\Temp\Fortinet_CA_SSL(3).cer" -Force
#endregion ImportCertificates

#region CreateStartupScheduledTask
# This region creates a logon script ($script variable is content of powershell script) which is set as a Logon Scheduled Task for the publicuser account (which can be done when the user doesn't exist yet)
# Order of tasks is oddly important as when Frozen the task bar settings revert to default about half way through the script so those settings put last.

# I don't fully understand how the C# code works however the gist is:
# STDMETHODCALLTYPE SetEndpointVisibility(PCWSTR, INT) accepts the device ID and either a true/false
# This then either enables or disables the audio device
# As I don't know how the public method SetEndpointVisibility can be redesigned to accept the boolean parameter I've taken the easy way out and
# duplicated it as SetEndpointVisibility2 and changed the public function to enable instead of disable.
# This code could obviously be improved by someone capable in C#!

$script = @'
#create C# Code
$cSharpSourceCode = @"
using System;
using System.Runtime.InteropServices;

public enum ERole : uint
{
    eConsole         = 0,
    eMultimedia      = 1,
    eCommunications  = 2,
    ERole_enum_count = 3
}

[Guid("F8679F50-850A-41CF-9C72-430F290290C8"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
internal interface IPolicyConfig
{
    // HRESULT GetMixFormat(PCWSTR, WAVEFORMATEX **);
    [PreserveSig]
    int GetMixFormat();
    
    // HRESULT STDMETHODCALLTYPE GetDeviceFormat(PCWSTR, INT, WAVEFORMATEX **);
    [PreserveSig]
	int GetDeviceFormat();
	
    // HRESULT STDMETHODCALLTYPE ResetDeviceFormat(PCWSTR);
    [PreserveSig]
    int ResetDeviceFormat();
    
    // HRESULT STDMETHODCALLTYPE SetDeviceFormat(PCWSTR, WAVEFORMATEX *, WAVEFORMATEX *);
    [PreserveSig]
    int SetDeviceFormat();
	
    // HRESULT STDMETHODCALLTYPE GetProcessingPeriod(PCWSTR, INT, PINT64, PINT64);
    [PreserveSig]
    int GetProcessingPeriod();
	
    // HRESULT STDMETHODCALLTYPE SetProcessingPeriod(PCWSTR, PINT64);
    [PreserveSig]
    int SetProcessingPeriod();
	
    // HRESULT STDMETHODCALLTYPE GetShareMode(PCWSTR, struct DeviceShareMode *);
    [PreserveSig]
    int GetShareMode();
	
    // HRESULT STDMETHODCALLTYPE SetShareMode(PCWSTR, struct DeviceShareMode *);
    [PreserveSig]
    int SetShareMode();
	 
    // HRESULT STDMETHODCALLTYPE GetPropertyValue(PCWSTR, const PROPERTYKEY &, PROPVARIANT *);
    [PreserveSig]
    int GetPropertyValue();
	
    // HRESULT STDMETHODCALLTYPE SetPropertyValue(PCWSTR, const PROPERTYKEY &, PROPVARIANT *);
    [PreserveSig]
    int SetPropertyValue();
	
    // HRESULT STDMETHODCALLTYPE SetDefaultEndpoint(__in PCWSTR wszDeviceId, __in ERole role);
    [PreserveSig]
    int SetDefaultEndpoint(
        [In] [MarshalAs(UnmanagedType.LPWStr)] string wszDeviceId, 
        [In] [MarshalAs(UnmanagedType.U4)] ERole role);
	
    // HRESULT STDMETHODCALLTYPE SetEndpointVisibility(PCWSTR, INT);
    [PreserveSig]
	int SetEndpointVisibility(
        [In] [MarshalAs(UnmanagedType.LPWStr)] string wszDeviceId, 
        [In] [MarshalAs(UnmanagedType.Bool)] bool bVisible);
}

[ComImport, Guid("870AF99C-171D-4F9E-AF0D-E63DF40C2BC9")]
internal class _CPolicyConfigClient
{
}

public class PolicyConfigClient
{
    public static int SetDefaultDevice(string deviceID)
    {
        IPolicyConfig _policyConfigClient = (new _CPolicyConfigClient() as IPolicyConfig);

	try
        {
            Marshal.ThrowExceptionForHR(_policyConfigClient.SetDefaultEndpoint(deviceID, ERole.eConsole));
		    Marshal.ThrowExceptionForHR(_policyConfigClient.SetDefaultEndpoint(deviceID, ERole.eMultimedia));
		    Marshal.ThrowExceptionForHR(_policyConfigClient.SetDefaultEndpoint(deviceID, ERole.eCommunications));
		    return 0;
        }
        catch
        {
            return 1;
        }
    }

    public static int SetEndpointVisibility(string deviceID)
    {
        IPolicyConfig _policyConfigClient = (new _CPolicyConfigClient() as IPolicyConfig);

	try
        {
            Marshal.ThrowExceptionForHR(_policyConfigClient.SetEndpointVisibility(deviceID, false));
		    return 0;
        }
        catch
        {
            return 1;
        }
    }

    public static int SetEndpointVisibility2(string deviceID)
    {
        IPolicyConfig _policyConfigClient = (new _CPolicyConfigClient() as IPolicyConfig);

	try
        {
            Marshal.ThrowExceptionForHR(_policyConfigClient.SetEndpointVisibility(deviceID, true));
		    return 0;
        }
        catch
        {
            return 1;
        }
    }
}
"@

add-type -TypeDefinition $cSharpSourceCode

function Set-DefaultAudioDevice
{
    Param
    (
        [parameter(Mandatory=$true)]
        [string[]]
        $deviceId
    )

    If ([PolicyConfigClient]::SetDefaultDevice("{0.0.0.00000000}.$deviceId") -eq 0)
    {
        Write-Host "SUCCESS: The default audio device has been set."
    }
    Else
    {
        Write-Host "ERROR: There has been a problem setting the default audio device."
    }
}

function Set-EndpointVisibility
{
    Param
    (
        [parameter(Mandatory=$true)]
        [string[]]
        $deviceId
    )

    If ([PolicyConfigClient]::SetEndpointVisibility("{0.0.0.00000000}.$deviceId") -eq 0)
    {
        Write-Host "SUCCESS: The audio device has been disabled."
    }
    Else
    {
        Write-Host "ERROR: There has been a problem disabling the audio device."
    }
}

function Set-EndpointVisibilityEnable
{
    Param
    (
        [parameter(Mandatory=$true)]
        [string[]]
        $deviceId
    )

    If ([PolicyConfigClient]::SetEndpointVisibility2("{0.0.0.00000000}.$deviceId") -eq 0)
    {
        Write-Host "SUCCESS: The audio device has been enabled."
    }
    Else
    {
        Write-Host "ERROR: There has been a problem enabling the audio device."
    }
}
# Runs CSharp code to disable audio
$registryLocation = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render\"
$audio = Get-ChildItem -Path $registryLocation | ForEach-Object {Get-ItemProperty -Path $_.PsPath | Where-Object {$_.DeviceState -eq 1} | Select-Object PSChildName}

if ($audio.PSChildName -ne $null) {
    ForEach ($a in $audio) {
        Set-EndpointVisibility $a.PSChildName
    }
}

# Runs C# code to enable headphones audio
$audioList = Get-ChildItem -Path $registryLocation | ForEach-Object {Get-ItemProperty -Path $_.PsPath | Select-Object PSChildName}
$result = $audioList | ForEach-Object { Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render\$($_.PSChildName)\Properties\" | Where-Object {$_."{a45c254e-df1c-4efd-8020-67d146a850e0},2" -eq "Headphones"} | Select-Object PSParentPath }

If ($result.PSParentPath -ne $null) {
    ForEach ($r in $result) {
        Set-EndpointVisibilityEnable $r.PSParentPath.split('\')[9]
    }
}

# Sets Proxy Settings
$registryLocation = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"

Set-ItemProperty -Name "ProxyEnable" -Path $registryLocation -Type DWord -Value "1" -Force
Set-ItemProperty -Name "ProxyServer" -Path $registryLocation -Type string -Value "172.18.20.9:8080" -Force

# Set ICAMIDLE Screensaver
$registryLocation = "HKCU:\Control Panel\Desktop"
Set-ItemProperty -Name "ScreenSaveActive" -Path $registryLocation -Value 1
Set-ItemProperty -Name "ScreenSaveTimeOut" -Path $registryLocation -Value 60
Set-ItemProperty -Name "scrnsave.exe" -Path $registryLocation -Value "C:\Windows\SysWOW64\ICAMIDLE.scr"

# Uninstall Teams each login as it reinstalls itself with updates and we can't stop it
Get-AppxPackage -Name "*teams" | Remove-AppxPackage

# Sets Windows 11 Application Startup Delay to 0 from Default of 10 Seconds
$registryLocation = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize"
if(-not(Test-Path $registryLocation)){
	New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\" -Name "Serialize"
}
Set-ItemProperty -Path $registryLocation -Name "StartupDelayInMSec" -Value "0"

# Set Default Printer and enable Legacy Printer Mode (to stop Acrobat Reader using the wrong printer)
$registryLocation = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows"
Set-ItemProperty -Path $registryLocation -Name "LegacyDefaultPrinterMode" -Type DWord -Value "1" -Force
Set-ItemProperty -Path $registryLocation -Name "Device" -Value "iCAM Printer,winspool,NUL"

# Remove Edge and MS Store from Task Bar
$apps = ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items())
foreach ($app in $apps) {
    $appname = $app.Name
    if ($appname -like "*store*") {
        $finalname = $app.Name
    }
}

((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $finalname}).Verbs() | ?{$_.Name.replace('&','') -match 'Unpin from taskbar'} | %{$_.DoIt(); $exec = $true}

$apps = ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items())
foreach ($app in $apps) {
    $appname = $app.Name
    if ($appname -like "*edge*") {
        $finalname = $app.Name
    }
}

((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $finalname}).Verbs() | ?{$_.Name.replace('&','') -match 'Unpin from taskbar'} | %{$_.DoIt(); $exec = $true}

# Turn off notifications
Set-ItemProperty -Name "ToastEnabled" -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications" -Type DWord -Value "0"

# Sets IP Address based on Computer Name
$printRegistryPath = "HKLM:\SOFTWARE\Insight Media\Print Client"
$cafeRegistryPath = "HKLM:\SOFTWARE\Insight Media\Cafe Client"

$computerPrefix = $env:COMPUTERNAME.Substring(0,3)

switch ($computerPrefix) {
    APP 
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.101.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.101.10"
    }
    ASH 
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.102.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.102.10"
    }
    AXM
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.103.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.103.10"
    }
    BAM
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.104.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.104.10"
    }
    BAR
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.105.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.105.10"
    }
    BID
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.106.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.106.10"
    }
    BOV
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.107.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.107.10"
    }
    BRA
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.108.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.108.10"
    }
    BUC 
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.109.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.109.10"
    }
    BUD
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.110.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.110.10"
    }
    CHA
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.111.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.111.10"
    }
    CHD
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.112.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.112.10"
    }
    CHM
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.113.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.113.10"
    }
    CLY
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.114.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.114.10"
    }
    COL
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.115.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.115.10"
    }
    COM
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.116.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.116.10"
    }
    CRE
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.117.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.117.10"
    }
    CUL
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.118.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.118.10"
    }
    DAR
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.119.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.119.10"
    }
    DAW
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.120.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.120.10"
    }
    EXE
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.121.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.121.10"
    }
    EXM
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.122.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.122.10"
    }
    HOL
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.123.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.123.10"
    }
    HON
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.124.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.124.10"
    }
    ILF
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.125.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.125.10"
    }
    IVY
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.126.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.126.10"
    }
    KGB
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.127.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.127.10"
    }
    KGK
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.128.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.128.10"
    }
    KGS
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.129.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.129.10"
    }
    LYN
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.130.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.130.10"
    }
    MOR
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.131.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.131.10"
    }
    NEW
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.132.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.132.10"
    }
    NOR
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.133.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.133.10"
    }
    OKE
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.134.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.134.10"
    }
    OTT
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.135.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.135.10"
    }
    PIN
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.136.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.136.10"
    }
    PRI
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.137.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.137.10"
    }
    SAL
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.138.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.138.10"
    }
    SEA
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.139.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.139.10"
    }
    SID
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.140.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.140.10"
    }
    SOU
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.141.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.141.10"
    }
    STT
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.142.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.142.10"
    }
    STO
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.143.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.143.10"
    }
    TAV
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.144.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.144.10"
    }
    TEI
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.145.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.145.10"
    }
    TIV
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.146.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.146.10"
    }
    TOP
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.147.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.147.10"
    }
    TOR
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.148.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.148.10"
    }
    TOT
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.149.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.149.10"
    }
    UFF
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.150.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.150.10"
    }
    BRI
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.151.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.151.10"
    }
    CHU
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.152.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.152.10"
    }
    PAI
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.153.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.153.10"
    }
    TQY
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.154.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.154.10"
    }
    Pha
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "10.0.132.10"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "10.0.132.10"
    }
    Default 
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "99.99.99.99"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "99.99.99.99"   
    }
}

# Set Mailto to use bat file and go to website instead of opening Outlook
$torbay = @"
@echo off
start chrome https://www.torbaylibraries.org.uk/web/arena/webmaillinks
"@

$devon = @"
@echo off
start chrome https://www.devonlibraries.org.uk/web/arena/webmaillinks
"@

$path = "C:\Program Files\Libraries Unlimited"

switch ($computerPrefix) {
    {($_ -eq "BRI") -or ($_ -eq "CHU") -or ($_ -eq "PAI") -or ($_ -eq "TQY")}
        {
            $torbay | Out-File -FilePath "$path\launchurl.bat" -Encoding ascii
        }
    Default
        {
            $devon | Out-File -FilePath "$path\launchurl.bat" -Encoding ascii
        }
}

# Disable Audacity Alpha Update screen
$audacity = @"
[Locale]
Language=en
[Update]
DefaultUpdatesChecking=0
UpdateNoticeShown=1
"@

$path = "C:\Users\LibraryPublicUser\AppData\Roaming\audacity"
if(-not(Test-Path $path)) {
    New-Item -path $path -ItemType Directory
}
$audacity | Out-File -FilePath "$path\audacity.cfg" -Encoding ascii

# Disable "Minimize windows when a monitor is disconnected" option to stop iCAM being hidden when someone turns off the monitor
Set-ItemProperty -Name "MonitorRemovalRecalcBehavior" -Path "HKCU:\Control Panel\Desktop" -Type DWord -Value "1"

# Hide unwanted Task Bar icons
Set-ItemProperty -Name "TaskbarDa" -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Type DWord -Value "0"
Set-ItemProperty -Name "ShowTaskViewButton" -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Type DWord -Value "0"
#Set-ItemProperty -Name "StartShownOnUpgrade" -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Type DWord -Value "0"
Set-ItemProperty -Name "TaskBarMn" -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Type DWord -Value "0"
Set-ItemProperty -Name "ShowCopilotButton" -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Type DWord -Value "0"

'@

$path = "C:\Program Files\Libraries Unlimited"

if(-not(Test-Path $path)) {
    New-Item -path $path -ItemType Directory
}

# Set Permissions for Libraries Unlimited directory as Full Control for everyone for launchurl.bat tweaks during startup
$InheritanceFlag = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [System.Security.AccessControl.InheritanceFlags]::ObjectInherit
$PropagationFlag = [System.Security.AccessControl.PropagationFlags]::None
$fileACL = Get-ACL -Path $path -EA SilentlyContinue
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Users","FullControl",$InheritanceFlag,$PropagationFlag,"Allow")
$fileACL.SetAccessRule($accessRule)
$fileACL | Set-ACL -Path $path

$script | Out-File -FilePath "$path\Startup.ps1" -Encoding ascii

$trigger = New-ScheduledTaskTrigger -AtLogOn -User "$env:computername\LibraryPublicUser"
$user = "$env:computername\LibraryPublicUser"
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File ""$path\Startup.ps1"""

Register-ScheduledTask -TaskName "LU Startup" -User $user -Trigger $trigger -Action $action
#endregion CreateStartupScheduledTask

#region CreateAssociationScheduledTask
$path = "C:\Program Files\Libraries Unlimited"

Invoke-WebRequest "https://raw.githubusercontent.com/LibrariesUnlimited/DeepFreeze-Cloud/main/SetFileAssociations.ps1" -OutFile "C:\Program Files\Libraries Unlimited\SetFileAssociations.ps1"

$trigger = New-ScheduledTaskTrigger -AtLogOn -User "$env:computername\LibraryPublicUser"
$user = "$env:computername\LibraryPublicUser"
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File ""$path\SetFileAssociations.ps1"""

Register-ScheduledTask -TaskName "LU File Associations" -User $user -Trigger $trigger -Action $action
#endregion CreateAssociationScheduledTask

#region CopyFiles
# Download required icon and other files from iCAM Server
if(-not(Test-Path "C:\Program Files (x86)\iCAM\Workstation Control\CPL")) {
    New-Item -path "C:\Program Files (x86)\iCAM\Workstation Control\CPL" -ItemType Directory
}
Invoke-WebRequest "https://devon.imil.uk/adverts/test/email2.ico" -OutFile "C:\Program Files (x86)\iCAM\Workstation Control\CPL\email2.ico"
Invoke-WebRequest "https://devon.imil.uk/adverts/test/Sound.ico" -OutFile "C:\Program Files (x86)\iCAM\Workstation Control\CPL\Sound.ico"
Invoke-WebRequest "https://devon.imil.uk/adverts/test/Sound.exe" -OutFile "C:\Program Files (x86)\iCAM\Workstation Control\CPL\Sound.exe"
Invoke-WebRequest "https://devon.imil.uk/adverts/test/Ease of Access.ico" -OutFile "C:\Program Files (x86)\iCAM\Workstation Control\CPL\Ease of Access.ico"
Invoke-WebRequest "https://devon.imil.uk/adverts/test/libraries.ico" -OutFile "C:\Program Files (x86)\iCAM\Workstation Control\CPL\libraries.ico"
Invoke-WebRequest "https://devon.imil.uk/adverts/test/Desktop.ico" -OutFile "C:\Program Files (x86)\iCAM\Workstation Control\CPL\Desktop.ico"
Invoke-WebRequest "https://devon.imil.uk/adverts/test/calendar2.ico" -OutFile "C:\Program Files (x86)\iCAM\Workstation Control\CPL\calendar2.ico"
Invoke-WebRequest "https://devon.imil.uk/adverts/test/Books.ico" -OutFile "C:\Program Files (x86)\iCAM\Workstation Control\CPL\Books.ico"
Invoke-WebRequest "https://devon.imil.uk/adverts/test/Newspapers.ico" -OutFile "C:\Program Files (x86)\iCAM\Workstation Control\CPL\Newspapers.ico"
Invoke-WebRequest "https://devon.imil.uk/adverts/test/mspaint.ico" -OutFile "C:\Program Files (x86)\iCAM\Workstation Control\CPL\mspaint.ico"
Invoke-WebRequest "https://devon.imil.uk/adverts/test/WBDBT32I.DLL" -OutFile "C:\Program Files (x86)\iCAM\Workstation Control\CPL\WBDBT32I.DLL"
Invoke-WebRequest "https://devon.imil.uk/adverts/test/borrowbox.ico" -OutFile "C:\Program Files (x86)\iCAM\Workstation Control\CPL\borrowbox.ico"
Invoke-WebRequest "https://devon.imil.uk/adverts/test/theorytest.ico" -OutFile "C:\Program Files (x86)\iCAM\Workstation Control\CPL\theorytest.ico"
Invoke-WebRequest "https://devon.imil.uk/adverts/test/gocitizen.ico" -OutFile "C:\Program Files (x86)\iCAM\Workstation Control\CPL\gocitizen.ico"
Invoke-WebRequest "https://devon.imil.uk/adverts/test/ancestry.ico" -OutFile "C:\Program Files (x86)\iCAM\Workstation Control\CPL\ancestry.ico"


# Download Backgrounds from iCAM Server
#Invoke-WebRequest "https://devon.imil.uk/adverts/test/desktop1920x1032.jpg" -OutFile "C:\Program Files (x86)\iCAM\Workstation Control\desktop1920x1032.jpg"
Invoke-WebRequest "https://devon.imil.uk/adverts/test/childdesktop1920x1032.jpg" -OutFile "C:\Program Files (x86)\iCAM\Workstation Control\childdesktop1920x1032.jpg"
Invoke-WebRequest "https://devon.imil.uk/adverts/test/newdesktop1920x1032.jpg" -OutFile "C:\Program Files (x86)\iCAM\Workstation Control\newdesktop1920x1032.jpg"
Invoke-WebRequest "https://devon.imil.uk/adverts/test/background.jpg" -OutFile "C:\Program Files\Libraries Unlimited\background.jpg"

# Download launchurl.bat from iCAM Server (not needed in new way, created by startup script, hopefully)
# Invoke-WebRequest "https://devon.imil.uk/adverts/test/launchurl.bat" -OutFile "C:\Windows\launchurl.bat"
#endregion CopyFiles

#region WindowsRegistrySettings
# Hiding Sleep and Shutdown from Start Menu
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Start\HideShutDown" -Name "value" -Value "1"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Start\HideSleep" -Name "value" -Value "1"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Start\HideLock" -Name "value" -Value "1"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Start\HideChangeAccountSettings" -Name "value" -Value "1"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Start\HideSignOut" -Name "value" -Value "1"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Start\HideSwitchAccount" -Name "value" -Value "1"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Start\HideRecentlyAddedApps" -Name "value" -Value "1"

# Set Power Management for NIC
$registryLocation = "HKLM:\System\CurrentControlSet\Control\Power"
Set-ItemProperty -Path $registryLocation -Name "PlatformAoAcOverride" -Value 0 -Type DWord

# Disable access to Windows Screensaver from Control Panel (can still be accessed via changing Registry Settings, possibly causing an iCAM problem)
#Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "NoDispScrSavPage" -Type DWord -Value 1

# Set Power Settings for default power profile
powercfg.exe /X monitor-timeout-ac 0
powercfg.exe /X monitor-timeout-dc 0
powercfg.exe /X disk-timeout-ac 0
powercfg.exe /X disk-timeout-dc 0
powercfg.exe /X standby-timeout-ac 0
powercfg.exe /X standby-timeout-dc 0
powercfg.exe /X hibernate-timeout-ac 0
powercfg.exe /X hibernate-timeout-dc 0

# Set Wallpaper
$registryLocation = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"
New-Item -Path $registryLocation -Force -ErrorAction SilentlyContinue | Out-Null
Set-ItemProperty -Path $registryLocation -Name 'DesktopImageStatus' -Value 1 -Type DWord
Set-ItemProperty -Path $registryLocation -Name 'DesktopImagePath' -Value "C:\Program Files\Libraries Unlimited\background.jpg" -Type String 

# Disable OneDrive
$registryLocation = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive"
if(-not(Test-Path $registryLocation)){
	New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\" -Name "OneDrive"
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Value 1 -Type DWord

# Remove Recently Added Apps from Start Menu
$registryLocation = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
if(-not(Test-Path $registryLocation)){
	New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\" -Name "Explorer"
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "HideRecentlyAddedApps" -Value 1 -Type DWord

# Disable Device Management warning
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" -Name "Enabled" -Value "0"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" -Name "EnabledBootId" -Value "0"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" -Name "WasEnabledBy" -Value "0"

# Setup Mailto Registry (this might need tweaking to get the quotes around the value correctly)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Classes\Outlook.URL.mailto.15\shell\open\command" -Name "(Default)" -Value "C:\Windows\System32\cmd.exe /c ""C:\Program Files\Libraries Unlimited\launchurl.bat"""

# Disable Cortana
$registryLocation = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
if(-not(Test-Path $registryLocation)){
	New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\" -Name "Windows Search"
}
Set-ItemProperty -Path $registryLocation -Name "AllowCortana" -Value "0"

# Disable Firewall for printing (can we improve this and not have the firewall completely off?)
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# Disable Copilot Completely
$registryLocation = "HKLM:\Software\Policies\Microsoft\Windows\WindowsCopilot"
$registryName = "TurnOffWindowsCopilot"
if(-not(Test-Path $registryLocation)){
    New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows" -Name "WindowsCopilot"
}
Set-ItemProperty -Path $registryLocation -Name $registryName -Type DWord -Value "1"

# Disable Chrome Full-Tab Promotional Content
$registryLocation = "HKLM:\Software\Policies\Google\Chrome"
$registryName = "PromotionalTabsEnabled"
if(-not(Test-Path "HKLM:\Software\Policies\Google")){
    New-Item -Path "HKLM:\Software\Policies\" -Name "Google"
}
if(-not(Test-Path "HKLM:\Software\Policies\Google\Chrome")){
    New-Item -Path "HKLM:\Software\Policies\Google\" -Name "Chrome"
}
Set-ItemProperty -Path $registryLocation -Name "PromotionalTabsEnabled" -Type DWord -Value "0" -Force

#Block Specific Chrome Extensions
$registryLocation = "HKLM:\Software\Policies\Google\Chrome\ExtensionInstallBlocklist"
if(-not(Test-Path "HKLM:\Software\Policies\Google\Chrome\ExtensionInstallBlocklist")){
    New-Item -Path "HKLM:\Software\Policies\Google\Chrome" -Name "ExtensionInstallBlocklist"
    Write-Output "Chrome ExtensionInstallBlocklist Registry entry did not exist"
    Write-Output "---------------------"
}
#Browsec VPN
Set-ItemProperty -Path $registryLocation -Name "1" -Type String -Value "omghfjlpggmjjaagoclmmobgdodcjboh" -Force

# Disable Chrome ZstdContentEncodingEnabled
$registryLocation = "HKLM:\Software\Policies\Google\Chrome"
$registryName = "ZstdContentEncodingEnabled"
if(-not(Test-RegistryValue -Path $registryLocation -Name $registryName))
{
    if(-not(Test-Path "HKLM:\Software\Policies\Google")){
        New-Item -Path "HKLM:\Software\Policies\" -Name "Google"
    }
    if(-not(Test-Path "HKLM:\Software\Policies\Google\Chrome")){
        New-Item -Path "HKLM:\Software\Policies\Google\" -Name "Chrome"
    }
    Set-ItemProperty -Path $registryLocation -Name "ZstdContentEncodingEnabled" -Type DWord -Value "0" -Force
}
if ((Get-ItemProperty -Path $registryLocation -Name $registryName).ZstdContentEncodingEnabled -ne 0) {
    Set-ItemProperty -Path $registryLocation -Name "ZstdContentEncodingEnabled" -Type DWord -Value "0" -Force
}

# Disable Edge ZstdContentEncodingEnabled
$registryLocation = "HKLM:\Software\Policies\Microsoft\Edge"
$registryName = "ZstdContentEncodingEnabled"
if(-not(Test-RegistryValue -Path $registryLocation -Name $registryName))
{
    if(-not(Test-Path "HKLM:\Software\Policies\Microsoft")){
        New-Item -Path "HKLM:\Software\Policies\" -Name "Microsoft"
    }
    if(-not(Test-Path "HKLM:\Software\Policies\Microsoft\Edge")){
        New-Item -Path "HKLM:\Software\Policies\Microsoft\" -Name "Edge"
    }
    Set-ItemProperty -Path $registryLocation -Name "ZstdContentEncodingEnabled" -Type DWord -Value "0" -Force
}
if ((Get-ItemProperty -Path $registryLocation -Name $registryName).ZstdContentEncodingEnabled -ne 0) {
    Set-ItemProperty -Path $registryLocation -Name "ZstdContentEncodingEnabled" -Type DWord -Value "0" -Force
}

#Block Specific Edge Extensions
$registryLocation = "HKLM:\Software\Policies\Microsoft\Edge\ExtensionInstallBlocklist"
if(-not(Test-Path "HKLM:\Software\Policies\Microsoft\Edge\ExtensionInstallBlocklist")){
    New-Item -Path "HKLM:\Software\Policies\Microsoft\Edge" -Name "ExtensionInstallBlocklist"
    Write-Output "Edge ExtensionInstallBlocklist Registry entry did not exist"
    Write-Output "---------------------"
}
#Browsec VPN
Set-ItemProperty -Path $registryLocation -Name "1" -Type String -Value "fjnehcbecaggobjholekjijaaekbnlgj" -Force

# Disable Firefox Zstd Encoding
$registryLocation = "HKLM:\Software\Policies\Mozilla\Firefox"
$registryName = "Preferences"
$value = @('{','"network.http.accept-encoding.secure": {','"Value": "gzip, deflate, br",','"Status": "default"','}','}')
if(-not(Test-RegistryValue -Path $registryLocation -Name $registryName))
{
    if(-not(Test-Path "HKLM:\Software\Policies\Mozilla")){
        New-Item -Path "HKLM:\Software\Policies\" -Name "Mozilla"
    }
    if(-not(Test-Path "HKLM:\Software\Policies\Mozilla\Firefox")){
        New-Item -Path "HKLM:\Software\Policies\Mozilla\" -Name "Firefox"
    }
    Set-ItemProperty -Path $registryLocation -Name "Preferences" -Type MultiString -Value $value -Force
}
Set-ItemProperty -Path $registryLocation -Name "Preferences" -Type MultiString -Value $value -Force

#Block Specific FireFox Extensions
$registryLocation = "HKLM:\Software\Policies\Mozilla\Firefox\ExtensionSettings"

if(-not(Test-Path "HKLM:\Software\Policies\Mozilla\Firefox\ExtensionSettings")){
    New-Item -Path "HKLM:\Software\Policies\Mozilla\Firefox\" -Name "ExtensionSettings"
    Write-Output "FireFox ExtensionSettings Registry entry did not exist"
    Write-Output "---------------------"
}
#Browsec VPN
Set-ItemProperty -Path $registryLocation -Name "browsec@browsec.com" -Type String -Value "blocked" -Force

#endregion WindowsRegistrySettings


