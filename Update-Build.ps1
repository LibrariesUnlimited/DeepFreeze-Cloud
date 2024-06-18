# Update-Build
# For adding changes to the Registry that require SYSTEM / Administrator permissions
# If a change is made in this script then a corresponding change should be made to the build
# HOWEVER ... this script should check to see if changes are required to speed processing and restrict errors
# Eventually all machines will have updates from this script applied so in theory it could be stopped but will be left running to have changes made at next Maintenance Period
# rather than waiting a week to change the DeepFreeze Cloud Policy


# Example ... this didn't work so need to do an HKLM version in this script
# Disable Copilot Completely (no permissions to create key so probably won't work commenting out for now)
#$registryLocation = "HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot"
#if(-not(Test-Path $registryLocation)){
#	New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows" -Name "WindowsCopilot"
#}
#Set-ItemProperty -Path $registryLocation -Name "TurnOffWindowsCopilot" -Type DWord -Value "1"

# Disable Copilot Completely
$registryLocation = "HKLM:\Software\Policies\Microsoft\Windows\WindowsCopilot"
if(-not(Test-Path $registryLocation)){
	New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows" -Name "WindowsCopilot"
}
Set-ItemProperty -Path $registryLocation -Name "TurnOffWindowsCopilot" -Type DWord -Value "1"

# Disable Chrome Full-Tab Promotional Content
$registryLocation = "HKLM:\Software\Policies\Google\Chrome"
if(-not(Test-Path "HKLM:\Software\Policies\Google")){
    New-Item -Path "HKLM:\Software\Policies\" -Name "Google"
}
if(-not(Test-Path "HKLM:\Software\Policies\Google\Chrome")){
    New-Item -Path "HKLM:\Software\Policies\Google\" -Name "Chrome"
}
Set-ItemProperty -Path $registryLocation -Name "PromotionalTabsEnabled" -Type DWord -Value "0" -Force