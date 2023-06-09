# POC Template for making modifications to iCAM Profiles post install, such as adding a scanner or special software to desktop.
# Not all entries will need to be included so only variations of default desktops required (delete those not needed)

$profiles = @('ADC','ADU','CHC','CHI','Default','OOH','STC','STU')


# Registry key/values for Adult Profiles
$adultValues = @{
    "Use Proxy Server" = 1
    "Proxy Server Port" = 8080
    "Proxy Server Host" = "172.18.20.81"
    "Terms and Conditions" = ""
    "Run on Unlock" = ""
    "Desktop Wallpaper" = "C:\Program Files (x86)\iCAM\Workstation Control\desktop1920x984.jpg"
    "Environment Profile" = "LU User"
    "RunMinimised" = 0
    "RunTaskBarOnly" = 0
    "Allow Windows Shutdown" = 0
    "Run Full Screen" = 1
    "HideMissingApps" = 1
    "Allow Extend Request" = 0
    "Allow Session Pause" = 0
    "Allow Help Request" = 0
    "Allow Request Help" = 0
    "Shortcut Font Name" = "Arial"
    "Shortcut Font Size" = 12
    "Shortcut Font Colour" = 16777215
    "Shortcut Font Style" = "fsBold"
    "Timer Position Left" = 10
    "Timer Position Top" = 8
    "Pause Session Postion Left" = 8
    "Pause Session Postion Top" = 96
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
    "Pause Session Height" = 24
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

# Registry key/values for Adult Applications
$adultApplicationsValues = @{
    "Internet"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://www.google.co.uk,,130,295,2"
    "Email"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://www.devonlibraries.org.uk/web/arena/webmaillinks,C:\Program Files (x86)\iCAM\Workstation Control\CPL\email2.ico,280,295,2"
    "Word"="C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE,,,125,600,0"
    "Powerpoint"="C:\Program Files\Microsoft Office\root\Office16\POWERPNT.EXE,,,225,710,0"
    "Excel"="C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE,,,225,600,0"
    "Publisher"="C:\Program Files\Microsoft Office\root\Office16\MSPUB.EXE,,,125,710,0"
    "File Explorer"="C:\WINDOWS\explorer.exe,,C:\WINDOWS\explorer.exe,325,600,0"
    "Computer Help"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://www.devonlibraries.org.uk/web/arena/computer-help,C:\Windows\HelpPane.exe,550,260,0"
    "Calculator"="c:\windows\system32\calc.exe,,,550,370,0"
    "Accessibility"="C:\Windows\explorer.exe,shell:::{D555645E-D4F8-4c29-A827-D93C859C4F2A},C:\Program Files (x86)\iCAM\Workstation Control\CPL\Ease of Access.ico,685,260,0"
    "Sound"="C:\Program Files (x86)\iCAM\Workstation Control\CPL\Sound.exe,,C:\Program Files (x86)\iCAM\Workstation Control\CPL\Sound.ico,685,370,0"
    "VLC - Media Player"="C:\Program Files\VideoLAN\VLC\vlc.exe,,,550,600,0"
    "GIMP - Graphics"="C:\Program Files\GIMP 2\bin\gimp-2.10.exe,,,550,710,0"
    "Paint - Graphics"="C:\Users\LUTestUser\AppData\Local\Microsoft\WindowsApps\Microsoft.Paint_8wekyb3d8bbwe\mspaint.exe,,,685,710,0"
    "Audacity - Audio"="C:\Program Files\Audacity\audacity.exe,,,685,600,0"
    "Reference Resources"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://www.devonlibraries.org.uk/web/arena/referenceonline,C:\Program Files (x86)\iCAM\Workstation Control\CPL\Newspapers.ico,1080,600,0"
    "Catalogue Search"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://www.devonlibraries.org.uk/web/arena/advanced-search,C:\Program Files (x86)\iCAM\Workstation Control\CPL\Books.ico,945,600,0"
    "Events"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://www.devonlibraries.org.uk/web/arena/events,C:\Program Files (x86)\iCAM\Workstation Control\CPL\calendar2.ico,945,710,0"
    "Online Services"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://www.devonlibraries.org.uk/web/arena/webresources,C:\Program Files (x86)\iCAM\Workstation Control\CPL\Desktop.ico,1080,710,0"
    "Support Us"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://www.librariesunlimited.org.uk/support-us/,C:\Program Files (x86)\iCAM\Workstation Control\CPL\libraries.ico,870,925,0"
}

# Registry key/values for Filtered Profiles
$filteredValues = @{
    "Use Proxy Server" = 1
    "Proxy Server Port" = 8080
    "Proxy Server Host" = "172.18.20.9"
    "Terms and Conditions" = ""
    "Run on Unlock" = ""
    "Desktop Wallpaper" = "C:\Program Files (x86)\iCAM\Workstation Control\desktop1920x984.jpg"
    "Environment Profile" = "LU User"
    "RunMinimised" = 0
    "RunTaskBarOnly" = 0
    "Allow Windows Shutdown" = 0
    "Run Full Screen" = 1
    "HideMissingApps" = 1
    "Allow Extend Request" = 0
    "Allow Session Pause" = 0
    "Allow Help Request" = 0
    "Allow Request Help" = 0
    "Shortcut Font Name" = "Arial"
    "Shortcut Font Size" = 12
    "Shortcut Font Colour" = 16777215
    "Shortcut Font Style" = "fsBold"
    "Timer Position Left" = 10
    "Timer Position Top" = 8
    "Pause Session Postion Left" = 8
    "Pause Session Postion Top" = 96
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
    "Pause Session Height" = 24
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

# Registry key/values for Filtered Applications (Currently the same as Adult)
$filteredApplicationsValues = @{
    "Internet"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://www.google.co.uk,,130,295,2"
    "Email"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://www.devonlibraries.org.uk/web/arena/webmaillinks,C:\Program Files (x86)\iCAM\Workstation Control\CPL\email2.ico,280,295,2"
    "Word"="C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE,,,125,600,0"
    "Powerpoint"="C:\Program Files\Microsoft Office\root\Office16\POWERPNT.EXE,,,225,710,0"
    "Excel"="C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE,,,225,600,0"
    "Publisher"="C:\Program Files\Microsoft Office\root\Office16\MSPUB.EXE,,,125,710,0"
    "File Explorer"="C:\WINDOWS\explorer.exe,,C:\WINDOWS\explorer.exe,325,600,0"
    "Computer Help"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://www.devonlibraries.org.uk/web/arena/computer-help,C:\Windows\HelpPane.exe,550,260,0"
    "Calculator"="c:\windows\system32\calc.exe,,,550,370,0"
    "Accessibility"="C:\Windows\explorer.exe,shell:::{D555645E-D4F8-4c29-A827-D93C859C4F2A},C:\Program Files (x86)\iCAM\Workstation Control\CPL\Ease of Access.ico,685,260,0"
    "Sound"="C:\Program Files (x86)\iCAM\Workstation Control\CPL\Sound.exe,,C:\Program Files (x86)\iCAM\Workstation Control\CPL\Sound.ico,685,370,0"
    "VLC - Media Player"="C:\Program Files\VideoLAN\VLC\vlc.exe,,,550,600,0"
    "GIMP - Graphics"="C:\Program Files\GIMP 2\bin\gimp-2.10.exe,,,550,710,0"
    "Paint - Graphics"="C:\Users\LUTestUser\AppData\Local\Microsoft\WindowsApps\Microsoft.Paint_8wekyb3d8bbwe\mspaint.exe,,,685,710,0"
    "Audacity - Audio"="C:\Program Files\Audacity\audacity.exe,,,685,600,0"
    "Reference Resources"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://www.devonlibraries.org.uk/web/arena/referenceonline,C:\Program Files (x86)\iCAM\Workstation Control\CPL\Newspapers.ico,1080,600,0"
    "Catalogue Search"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://www.devonlibraries.org.uk/web/arena/advanced-search,C:\Program Files (x86)\iCAM\Workstation Control\CPL\Books.ico,945,600,0"
    "Events"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://www.devonlibraries.org.uk/web/arena/events,C:\Program Files (x86)\iCAM\Workstation Control\CPL\calendar2.ico,945,710,0"
    "Online Services"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://www.devonlibraries.org.uk/web/arena/webresources,C:\Program Files (x86)\iCAM\Workstation Control\CPL\Desktop.ico,1080,710,0"
    "Support Us"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://www.librariesunlimited.org.uk/support-us/,C:\Program Files (x86)\iCAM\Workstation Control\CPL\libraries.ico,870,925,0"
}

# Registry key/values for Child Profiles
$childValues = @{
    "Use Proxy Server" = 1
    "Proxy Server Port" = 8080
    "Proxy Server Host" = "172.18.20.9"
    "Terms and Conditions" = ""
    "Run on Unlock" = ""
    "Desktop Wallpaper" = "C:\Program Files (x86)\iCAM\Workstation Control\childdesktop1920x984.jpg"
    "Environment Profile" = "LU User"
    "RunMinimised" = 0
    "RunTaskBarOnly" = 0
    "Allow Windows Shutdown" = 0
    "Run Full Screen" = 1
    "HideMissingApps" = 1
    "Allow Extend Request" = 0
    "Allow Session Pause" = 0
    "Allow Help Request" = 0
    "Allow Request Help" = 0
    "Shortcut Font Name" = "Arial"
    "Shortcut Font Size" = 12
    "Shortcut Font Colour" = 16777215
    "Shortcut Font Style" = "fsBold"
    "Timer Position Left" = 10
    "Timer Position Top" = 8
    "Pause Session Postion Left" = 8
    "Pause Session Postion Top" = 96
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
    "Pause Session Height" = 24
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
$childApplicationsValues = @{
    "Word"="C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE,,,125,260,0"
    "Powerpoint"="C:\Program Files\Microsoft Office\root\Office16\POWERPNT.EXE,,,225,370,0"
    "Excel"="C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE,,,225,260,0"
    "Publisher"="C:\Program Files\Microsoft Office\root\Office16\MSPUB.EXE,,,125,370,0"
    "File Explorer"="C:\WINDOWS\explorer.exe,,C:\WINDOWS\explorer.exe,325,260,0"
    "Calculator"="c:\windows\system32\calc.exe,,,550,370,0"
    "Accessibility"="C:\Windows\explorer.exe,shell:::{D555645E-D4F8-4c29-A827-D93C859C4F2A},C:\Program Files (x86)\iCAM\Workstation Control\CPL\Ease of Access.ico,685,260,0"
    "Sound"="C:\Program Files (x86)\iCAM\Workstation Control\CPL\Sound.exe,,C:\Program Files (x86)\iCAM\Workstation Control\CPL\Sound.ico,550,260,0"
    "VLC - Media Player"="C:\Program Files\VideoLAN\VLC\vlc.exe,,,155,600,0"
    "GIMP - Graphics"="C:\Program Files\GIMP 2\bin\gimp-2.10.exe,,,155,710,0"
    "Paint - Graphics"="C:\Users\LUTestUser\AppData\Local\Microsoft\WindowsApps\Microsoft.Paint_8wekyb3d8bbwe\mspaint.exe,,,290,710,0"
    "Audacity - Audio"="C:\Program Files\Audacity\audacity.exe,,,290,600,0"
}

#  ADC and ADU and Default and OOH the same (all adult), CHC and CHI the same (all child), STC and STU the same (child filter) 
switch ( $profiles ) {
    {($_ -eq "ADC") -or ($_ -eq "ADU") -or ($_ -eq "Default") -or ($_ -eq "OOH")} 
        {
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
            $profileName = $_
            $filteredValues.GetEnumerator() | ForEach-Object {
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\Application Launcher\$profileName" -Name $_.Key -Value $_.Value
            }

            $filteredApplicationsValues.GetEnumerator() | ForEach-Object {
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\Application Launcher\$profileName\Applications" -Name $_.Key -Value $_.Value
            }              
        }
}