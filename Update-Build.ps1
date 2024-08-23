# Update-Build
# For adding changes to the Registry that require SYSTEM / Administrator permissions
# If a change is made in this script then a corresponding change should be made to the build
# HOWEVER ... this script should check to see if changes are required to speed processing and restrict errors
# Eventually all machines will have updates from this script applied so in theory it could be stopped but will be left running to have changes made at next Maintenance Period
# rather than waiting a week to change the DeepFreeze Cloud Policy

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

# Example ... this didn't work so need to do an HKLM version in this script
# Disable Copilot Completely (no permissions to create key so probably won't work commenting out for now)
#$registryLocation = "HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot"
#if(-not(Test-Path $registryLocation)){
#	New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows" -Name "WindowsCopilot"
#}
#Set-ItemProperty -Path $registryLocation -Name "TurnOffWindowsCopilot" -Type DWord -Value "1"

# Disable Copilot Completely
$registryLocation = "HKLM:\Software\Policies\Microsoft\Windows\WindowsCopilot"
$registryName = "TurnOffWindowsCopilot"
# checks to see if the value already exists, if it doesn't then create it
if(-not(Test-RegistryValue -Path $registryLocation -Name $registryName))
{
    if(-not(Test-Path $registryLocation)){
	    New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows" -Name "WindowsCopilot"
    }
    Set-ItemProperty -Path $registryLocation -Name $registryName -Type DWord -Value "1"
}
# checks to see if the value is correct, if not correct it
if ((Get-ItemProperty -Path $registryLocation -Name $registryName).TurnOffWindowsCopilot -ne 1) {
    Set-ItemProperty -Path $registryLocation -Name $registryName -Type DWord -Value "1"
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
    Set-ItemProperty -Path $registryLocation -Name "PromotionalTabsEnabled" -Type DWord -Value "0" -Force
}
if ((Get-ItemProperty -Path $registryLocation -Name $registryName).PromotionalTabsEnabled -ne 0) {
    Set-ItemProperty -Path $registryLocation -Name "PromotionalTabsEnabled" -Type DWord -Value "0" -Force
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
}
if ((Get-ItemProperty -Path $registryLocation -Name $registryName).PromotionalTabsEnabled -ne 0) {
    Set-ItemProperty -Path $registryLocation -Name "PromotionalTabsEnabled" -Type DWord -Value "0" -Force
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


# Force restart if client killed
$registryLocation = "HKLM:\SOFTWARE\Insight Media\Cafe Client\Monitor"
if ((Get-ItemProperty -Path $registryLocation -Name "Monitor Force LogOff")."Monitor Force LogOff" -ne 1) {
    Set-ItemProperty -Path $registryLocation -Name "Monitor Force LogOff" -Type DWord -Value 1 -Force
}
if ((Get-ItemProperty -Path $registryLocation -Name "Monitor Interval")."Monitor Interval" -ne 60) {
    Set-ItemProperty -Path $registryLocation -Name "Monitor Interval" -Type DWord -Value 60 -Force
}

$registryLocation = "HKLM:\SOFTWARE\Insight Media\Cafe Client\Environment Profiles\LU User"
if ((Get-ItemProperty -Path $registryLocation -Name "Disable Ctrl Alt Del")."Disable Ctrl Alt Del" -ne 1) {
    Set-ItemProperty -Path $registryLocation -Name "Disable Ctrl Alt Del" -Type DWord -Value 1 -Force
}

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
            }
        }
    {($_ -eq "STC") -or ($_ -eq "STU")} 
        {
            $profileName = $_
            $filteredApplicationsValues.GetEnumerator() | ForEach-Object {
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Insight Media\Cafe Client\Application Launcher\$profileName\Applications" -Name $_.Key -Value $_.Value
            }              
        }
}