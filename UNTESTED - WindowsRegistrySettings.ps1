# UNTESTED - Windows 11 Registry Settings to clean up and configure Public PC

# Hiding Sleep and Shutdown from Start Menu
Set-ItemProperty -Path "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Start\HideShutDown" -Name "value" -Value "1"
Set-ItemProperty -Path "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Start\HideSleep" -Name "value" -Value "1"

# Set Mailto to use bat file and go to website instead of opening Outlook
# Currently will not work as Outlook not installed but also need to get launchurl.bat file from current public PCs and decide where to put them.

$computerPrefix = $env:COMPUTERNAME.Substring(0,3)
<#
switch ($computerPrefix) {
    {($_ -eq "BRI") -or ($_ -eq "CHU") -or ($_ -eq "PAI") -or ($_ -eq "TQY")}
        {
            Set-ItemProperty -Path "HKLM\SOFTWARE\Classes\Outlook.URL.mailto.15\shell\open\command" -Value "C:\Windows\System32\cmd.exe /c C:\xxxxxxxxx\launchurl.bat https://www.torbaylibraries.org.uk/web/arena/webmaillinks %1"
        }
    Default
        {
            Set-ItemProperty -Path "HKLM\SOFTWARE\Classes\Outlook.URL.mailto.15\shell\open\command" -Value "C:\Windows\System32\cmd.exe /c C:\xxxxxxxxx\launchurl.bat https://www.devonlibraries.org.uk/web/arena/webmaillinks %1"
        }
}
#>
