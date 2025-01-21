# Update-Build
# For adding changes to the Registry that require SYSTEM / Administrator permissions
# If a change is made in this script then a corresponding change should be made to the build
# HOWEVER ... this script should check to see if changes are required to speed processing and restrict errors
# Eventually all machines will have updates from this script applied so in theory it could be stopped but will be left running to have changes made at next Maintenance Period
# rather than waiting a week to change the DeepFreeze Cloud Policy

# In addition this script now deletes the SoftwareDistribution folder to clear out corrupted update files each maintenance (for now it will only be on select computers)
# This section is at the end of the script.

$logFile = "C:\Program Files\Libraries Unlimited\Update-Build.log"
Start-Transcript $logFile
Write-Output "Logging to $logFile"
Write-Output "###### START $(get-date) ##### "

Function Test-RegistryValue {
    param(
        [Alias("PSPath")]
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [String]$Path
        ,
        [Parameter(Position = 1, Mandatory = $true)]
        [String]$Name
        ,
        [Switch]$PassThru
    ) 

    process {
        if (Test-Path $Path) {
            $Key = Get-Item -LiteralPath $Path
            if ($Key.GetValue($Name, $null) -ne $null) {
                if ($PassThru) {
                    Get-ItemProperty $Path $Name
                } else {
                    $true
                }
            } else {
                $false
            }
        } else {
            $false
        }
    }
}

$path = "C:\Windows\System32\spool\PRINTERS"

# Set Permissions for Libraries Unlimited directory as Full Control for everyone for launchurl.bat tweaks during startup
# Set Permissions for %windir%\system32\spool\PRINTERS as Modify for BUILTIN\Users for printing to work
$InheritanceFlag = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [System.Security.AccessControl.InheritanceFlags]::ObjectInherit
$PropagationFlag = [System.Security.AccessControl.PropagationFlags]::None
$fileACL = Get-ACL -Path $path -EA SilentlyContinue
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Users","Modify",$InheritanceFlag,$PropagationFlag,"Allow")
$fileACL.SetAccessRule($accessRule)
$fileACL | Set-ACL -Path $path

# Set Power Management for NIC
$registryLocation = "HKLM:\System\CurrentControlSet\Control\Power"
Set-ItemProperty -Path $registryLocation -Name "PlatformAoAcOverride" -Value 0 -Type DWord

#Add Child Enviroment Profile
$registryLocation = "HKLM:\SOFTWARE\Insight Media\Cafe Client\Environment Profiles\LU Child User"
$registryName = "Disable Alt Escape"
# checks to see if the value already exists, if it doesn't then create it
if(-not(Test-RegistryValue -Path $registryLocation -Name $registryName))
{
    New-Item -Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\Environment Profiles\" -Name "LU Child User"
}
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
    Set-ItemProperty -Path $registryPath -Name "Disable Taskbar" -Value 0 -Type DWord #makes things ugly for now
    Set-ItemProperty -Path $registryPath -Name "Disable System Tray" -Value 1 -Type DWord
    Set-ItemProperty -Path $registryPath -Name "Disable Quick Launch" -Value 1 -Type DWord
    Set-ItemProperty -Path $registryPath -Name "Disable Windows Keys" -Value 1 -Type DWord
    Set-ItemProperty -Path $registryPath -Name "Disable Mouse Right Click" -Value 0 -Type DWord

    $profiles = @('CHC','CHI')
    $childValues = @{
        "Environment Profile" = "LU Child User"
    }

    switch ( $profiles ) {
        {($_ -eq "CHC") -or ($_ -eq "CHI")} 
            {
                $profileName = $_
                $childValues.GetEnumerator() | ForEach-Object {
                    Set-ItemProperty -Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\Application Launcher\$profileName" -Name $_.Key -Value $_.Value
                }
            }
    }


# Disable Copilot Completely
$registryLocation = "HKLM:\Software\Policies\Microsoft\Windows\WindowsCopilot"
$registryName = "TurnOffWindowsCopilot"
# checks to see if the value already exists, if it doesn't then create it
if(-not(Test-RegistryValue -Path $registryLocation -Name $registryName))
{
    if(-not(Test-Path $registryLocation)){
	    New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows" -Name "WindowsCopilot"
    }
    Write-Output "Copilot Registry entry did not exist"
    Write-Output "---------------------"
    Set-ItemProperty -Path $registryLocation -Name $registryName -Type DWord -Value "1"
}
# checks to see if the value is correct, if not correct it
if ((Get-ItemProperty -Path $registryLocation -Name $registryName).TurnOffWindowsCopilot -ne 1) {
    Set-ItemProperty -Path $registryLocation -Name $registryName -Type DWord -Value "1"
    Write-Output "Copilot Registry entry was incorrect"
    Write-Output "---------------------"
}

# Disable Chrome Full-Tab Promotional Content
$registryLocation = "HKLM:\Software\Policies\Google\Chrome"
$registryName = "PromotionalTabsEnabled"
if(-not(Test-RegistryValue -Path $registryLocation -Name $registryName))
{
    if(-not(Test-Path "HKLM:\Software\Policies\Google")){
        New-Item -Path "HKLM:\Software\Policies\" -Name "Google"
    }
    if(-not(Test-Path "HKLM:\Software\Policies\Google\Chrome")){
        New-Item -Path "HKLM:\Software\Policies\Google\" -Name "Chrome"
    }
    Write-Output "Chrome Full-Tab Promotional Content Registry entry did not exist"
    Write-Output "---------------------"
    Set-ItemProperty -Path $registryLocation -Name "PromotionalTabsEnabled" -Type DWord -Value "0" -Force
}
if ((Get-ItemProperty -Path $registryLocation -Name $registryName).PromotionalTabsEnabled -ne 0) {
    Set-ItemProperty -Path $registryLocation -Name "PromotionalTabsEnabled" -Type DWord -Value "0" -Force
    Write-Output "Chrome Full-Tab Promotional Content Registry entry was incorrect"
    Write-Output "---------------------"
}

# Disable Edge Full-Tab Promotional Content
$registryLocation = "HKLM:\Software\Policies\Microsoft\Edge"
$registryName = "PromotionalTabsEnabled"
if(-not(Test-RegistryValue -Path $registryLocation -Name $registryName))
{
    if(-not(Test-Path "HKLM:\Software\Policies\Microsoft")){
        New-Item -Path "HKLM:\Software\Policies\" -Name "Microsoft"
    }
    if(-not(Test-Path "HKLM:\Software\Policies\Microsoft\Edge")){
        New-Item -Path "HKLM:\Software\Policies\Microsoft\" -Name "Edge"
    }
    Set-ItemProperty -Path $registryLocation -Name "PromotionalTabsEnabled" -Type DWord -Value "0" -Force
    Write-Output "Edge Full-Tab Promotional Content Registry entry did not exist"
    Write-Output "---------------------"
}
if ((Get-ItemProperty -Path $registryLocation -Name $registryName).PromotionalTabsEnabled -ne 0) {
    Set-ItemProperty -Path $registryLocation -Name "PromotionalTabsEnabled" -Type DWord -Value "0" -Force
    Write-Output "Edge Full-Tab Promotional Content Registry entry was incorrect"
    Write-Output "---------------------"
}

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
    Write-Output "Chrome ZstdContentEncodingEnabled Registry entry did not exist"
    Write-Output "---------------------"
}
if ((Get-ItemProperty -Path $registryLocation -Name $registryName).ZstdContentEncodingEnabled -ne 0) {
    Set-ItemProperty -Path $registryLocation -Name "ZstdContentEncodingEnabled" -Type DWord -Value "0" -Force
    Write-Output "Chrome ZstdContentEncodingEnabled Registry entry was incorrect"
    Write-Output "---------------------"
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
    Write-Output "Edge ZstdContentEncodingEnabled Registry entry did not exist"
    Write-Output "---------------------"
}
if ((Get-ItemProperty -Path $registryLocation -Name $registryName).ZstdContentEncodingEnabled -ne 0) {
    Set-ItemProperty -Path $registryLocation -Name "ZstdContentEncodingEnabled" -Type DWord -Value "0" -Force
    Write-Output "Edge ZstdContentEncodingEnabled Registry entry incorrect"
    Write-Output "---------------------"
}

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
    Write-Output "Firefox Zstd Encoding Registry entry did not exist"
    Write-Output "---------------------"
}
Set-ItemProperty -Path $registryLocation -Name "Preferences" -Type MultiString -Value $value -Force
Write-Output "Firefox Zstd Encoding Registry entry incorrect"
Write-Output "---------------------"


# Force restart if client killed
$registryLocation = "HKLM:\SOFTWARE\Insight Media\Cafe Client\Monitor"
if ((Get-ItemProperty -Path $registryLocation -Name "Monitor Force LogOff")."Monitor Force LogOff" -ne 1) {
    Set-ItemProperty -Path $registryLocation -Name "Monitor Force LogOff" -Type DWord -Value 1 -Force
    Write-Output "iCAM Force Logoff Registry entry incorrect"
    Write-Output "---------------------"
}
if ((Get-ItemProperty -Path $registryLocation -Name "Monitor Interval")."Monitor Interval" -ne 60) {
    Set-ItemProperty -Path $registryLocation -Name "Monitor Interval" -Type DWord -Value 60 -Force
    Write-Output "iCAM Monitor Interval Registry entry incorrect"
    Write-Output "---------------------"
}

$registryLocation = "HKLM:\SOFTWARE\Insight Media\Cafe Client\Environment Profiles\LU User"
if ((Get-ItemProperty -Path $registryLocation -Name "Disable Ctrl Alt Del")."Disable Ctrl Alt Del" -ne 1) {
    Set-ItemProperty -Path $registryLocation -Name "Disable Ctrl Alt Del" -Type DWord -Value 1 -Force
    Write-Output "iCAM Disable Ctrl Alt Del Registry entry incorrect"
    Write-Output "---------------------"
}

Write-Output "END OF REGISTRY CHANGES"
Write-Output "---------------------"

# List of Profiles, remember if a profile is added here it needs to be added to the switch statement below
$profiles = @('ADC','ADU','Default','OOH','STC','STU')

# Registry key/values for Adult Applications
# "Calculator"="c:\windows\system32\calc.exe,,,550,370,0"
$adultApplicationsValues = @{
    "Catalogue Search"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://discover.librariesunlimited.org.uk/extended-search,C:\Program Files (x86)\iCAM\Workstation Control\CPL\Books.ico,937,587,1"
    "Online Services"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://discover.librariesunlimited.org.uk/web-resources,C:\Program Files (x86)\iCAM\Workstation Control\CPL\Desktop.ico,1072,697,1"
    "Computer Help"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://discover.librariesunlimited.org.uk/computer-help,C:\Windows\HelpPane.exe,1658,520,2"
    "Email"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://discover.librariesunlimited.org.uk/webmail-services,C:\Program Files (x86)\iCAM\Workstation Control\CPL\email2.ico,280,295,2"
    "Events"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://discover.librariesunlimited.org.uk/whats-on,C:\Program Files (x86)\iCAM\Workstation Control\CPL\calendar2.ico,937,697,1"
    "Reference Resources"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://discover.librariesunlimited.org.uk/-/digital-library,C:\Program Files (x86)\iCAM\Workstation Control\CPL\Newspapers.ico,1072,587,1"
}

# Registry key/values for Filtered Applications (Currently the same as Adult)
$filteredApplicationsValues = @{
    "Catalogue Search"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://discover.librariesunlimited.org.uk/extended-search,C:\Program Files (x86)\iCAM\Workstation Control\CPL\Books.ico,937,587,1"
    "Online Services"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://discover.librariesunlimited.org.uk/web-resources,C:\Program Files (x86)\iCAM\Workstation Control\CPL\Desktop.ico,1072,697,1"
    "Computer Help"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://discover.librariesunlimited.org.uk/computer-help,C:\Windows\HelpPane.exe,1658,520,2"
    "Email"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://discover.librariesunlimited.org.uk/webmail-services,C:\Program Files (x86)\iCAM\Workstation Control\CPL\email2.ico,280,295,2"
    "Events"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://discover.librariesunlimited.org.uk/whats-on,C:\Program Files (x86)\iCAM\Workstation Control\CPL\calendar2.ico,937,697,1"
    "Reference Resources"="C:\Program Files\Google\Chrome\Application\chrome.exe,https://discover.librariesunlimited.org.uk/-/digital-library,C:\Program Files (x86)\iCAM\Workstation Control\CPL\Newspapers.ico,1072,587,1"
}

#  ADC and ADU and Default and OOH the same (all adult), CHC and CHI the same (all child), STC and STU the same (child filter) 
switch ( $profiles ) {
    {($_ -eq "ADC") -or ($_ -eq "ADU") -or ($_ -eq "Default") -or ($_ -eq "OOH")} 
        {
            $profileName = $_
            $adultApplicationsValues.GetEnumerator() | ForEach-Object {
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\Application Launcher\$profileName\Applications" -Name $_.Key -Value $_.Value
                Write-Output "Change made to $profileName"
            }
        }
    {($_ -eq "STC") -or ($_ -eq "STU")} 
        {
            $profileName = $_
            $filteredApplicationsValues.GetEnumerator() | ForEach-Object {
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\Application Launcher\$profileName\Applications" -Name $_.Key -Value $_.Value
                Write-Output "Change made to $profileName"
            }              
        }
}

Write-Output "END OF iCAM CHANGES"
Write-Output "---------------------"

Write-Output "START OF SOFTWAREDISTRIBUTION DELETION"
Write-Output "---------------------"

$computerPrefix = $env:COMPUTERNAME.Substring(0,6)

switch ($computerPrefix) {
    EXEPC3 
    {
        try {
            Write-Verbose 'Clearing SoftwareDistribution\Download folder...'
            # Create (temporary) empty folder
            New-Item -ItemType Directory -Path ".\Empty" -ErrorAction SilentlyContinue
            # Mirror the empty directory to the folder to delete; this will effectively empty the folder.
            robocopy /MIR ".\Empty" "$env:SystemRoot\SoftwareDistribution\Download" /njh /njs /ndl /nc /ns /np /nfl #>nul 2>&1
            # Delete the folder now that it's empty
            Remove-Item "$env:SystemRoot\SoftwareDistribution\Download" -Force
            # Delete our temporary empty folder
            Remove-Item ".\Empty" -Force
        }
        catch {
            Write-Error $_
        }
        
        #Then remove all the other folders
        Write-Verbose 'Clearing SoftwareDistribution folder...'
        Remove-Item -Path "$env:SystemRoot\SoftwareDistribution\*" -Force -Verbose -Confirm:$false -Recurse -ErrorAction 'SilentlyContinue' -WarningAction 'SilentlyContinue'
        
    }
    NEWPC0 
    {
        try {
            Write-Verbose 'Clearing SoftwareDistribution\Download folder...'
            # Create (temporary) empty folder
            New-Item -ItemType Directory -Path ".\Empty" -ErrorAction SilentlyContinue
            # Mirror the empty directory to the folder to delete; this will effectively empty the folder.
            robocopy /MIR ".\Empty" "$env:SystemRoot\SoftwareDistribution\Download" /njh /njs /ndl /nc /ns /np /nfl #>nul 2>&1
            # Delete the folder now that it's empty
            Remove-Item "$env:SystemRoot\SoftwareDistribution\Download" -Force
            # Delete our temporary empty folder
            Remove-Item ".\Empty" -Force
        }
        catch {
            Write-Error $_
        }
        
        #Then remove all the other folders
        Write-Verbose 'Clearing SoftwareDistribution folder...'
        Remove-Item -Path "$env:SystemRoot\SoftwareDistribution\*" -Force -Verbose -Confirm:$false -Recurse -ErrorAction 'SilentlyContinue' -WarningAction 'SilentlyContinue'
        
    }
    PHASEO
    {
        
        $path = "C:\Program Files\Libraries Unlimited"
        
        Invoke-WebRequest "https://raw.githubusercontent.com/LibrariesUnlimited/DeepFreeze-Cloud/main/SetFileAssociations.ps1" -OutFile "C:\Program Files\Libraries Unlimited\SetFileAssociations.ps1"

        Invoke-WebRequest "https://raw.githubusercontent.com/LibrariesUnlimited/DeepFreeze-Cloud/main/Update-UpdateFix.ps1" -OutFile "C:\Program Files\Libraries Unlimited\Update-UpdateFix.ps1"

        $trigger = New-ScheduledTaskTrigger -AtLogOn -User "$env:computername\LibraryPublicUser"
        $user = "NT AUTHORITY\SYSTEM"
        $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File ""$path\Update-UpdateFix.ps1"""

        Register-ScheduledTask -TaskName "LU Windows Update Fix" -User $user -Trigger $trigger -Action $action
        
    }
}

Write-Output "END OF SOFTWAREDISTRIBUTION DELETION"
Write-Output "---------------------"

Stop-Transcript