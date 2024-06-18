# Update-Build
# For adding changes to the Registry that require SYSTEM / Administrator permissions
# If a change is made in this script then a corresponding change should be made to the build
# HOWEVER ... this script should check to see if changes are required to speed processing and restrict errors
# Eventually all machines will have updates from this script applied so in theory it could be stopped but will be left running to have changes made at next Maintenance Period
# rather than waiting a week to change the DeepFreeze Cloud Policy
Start-Transcript -path "C:\Program Files\Libraries Unlimited\Update-Build.Log"

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
if(-not(Test-RegistryValue -Path $registryLocation -Name $registryName))
{
    write-host "registry value missing copilot"
    if(-not(Test-Path $registryLocation)){
	    New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows" -Name "WindowsCopilot"
    }
    Set-ItemProperty -Path $registryLocation -Name $registryName -Type DWord -Value "1"
}
if ((Get-ItemProperty -Path $registryLocation -Name $registryName).TurnOffWindowsCopilot -ne 0) {
    write-host "registry value wrong copilot"
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

# FAKE VALUE
$registryLocation = "HKLM:\Software\Policies\Ewen\Chrome"
$registryName = "PromotionalTabsEnabled"
if(-not(Test-RegistryValue -Path $registryLocation -Name $registryName))
{
 write-host "registry value missing fake"
}


Stop-Transcript