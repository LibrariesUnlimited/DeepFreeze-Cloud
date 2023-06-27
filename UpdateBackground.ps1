# POC Template for making modifications to iCAM Profiles post install, such as adding a scanner or special software to desktop.
# Not all entries will need to be included so only variations of default desktops required (delete those not needed)

# Download Backgrounds from iCAM Server
Invoke-WebRequest "https://devon.imil.uk/adverts/test/desktop1920x984.jpg" -OutFile "C:\Program Files (x86)\iCAM\Workstation Control\desktop1920x984.jpg"
Invoke-WebRequest "https://devon.imil.uk/adverts/test/childdesktop1920x984.jpg" -OutFile "C:\Program Files (x86)\iCAM\Workstation Control\childdesktop1920x984.jpg"

$profiles = @('ADC','ADU','CHC','CHI','Default','OOH','STC','STU')

# Registry key/values for Adult Profiles
$adultValues = @{
    "Desktop Wallpaper" = "C:\Program Files (x86)\iCAM\Workstation Control\desktop1920x984.jpg"
}

# Registry key/values for Adult Applications
$adultApplicationsValues = @{
}

# Registry key/values for Filtered Profiles
$filteredValues = @{
    "Desktop Wallpaper" = "C:\Program Files (x86)\iCAM\Workstation Control\desktop1920x984.jpg"
}

# Registry key/values for Filtered Applications (Currently the same as Adult)
$filteredApplicationsValues = @{
}

# Registry key/values for Child Profiles
$childValues = @{
    "Desktop Wallpaper" = "C:\Program Files (x86)\iCAM\Workstation Control\childdesktop1920x984.jpg"
}

# Registry key/values for Child Applications
$childApplicationsValues = @{
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