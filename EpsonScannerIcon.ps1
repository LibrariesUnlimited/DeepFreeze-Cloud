<# Script to add scanner icon to Adult and Child desktop #>

$profiles = @('ADC','ADU','CHC','CHI','Default','OOH','STC','STU')

$adultApplicationsValues = @{
    "Scanner"="C:\Program Files (x86)\epson\Epson Scan 2\Core\es2launcher.exe,,,310,697,1"
}

$filteredApplicationsValues = @{
    "Scanner"="C:\Program Files (x86)\epson\Epson Scan 2\Core\es2launcher.exe,,,310,697,1"
}

$childApplicationsValues = @{
    "Scanner"="C:\Program Files (x86)\epson\Epson Scan 2\Core\es2launcher.exe,,,310,358,1"
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
    {($_ -eq "CHC") -or ($_ -eq "CHI")} 
        {
            $profileName = $_
            $childApplicationsValues.GetEnumerator() | ForEach-Object {
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