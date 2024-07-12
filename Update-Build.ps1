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

# Download files to local machine
Invoke-WebRequest "https://devon.imil.uk/adverts/test/Fortinet_CA_SSL(1).cer" -OutFile "C:\Windows\Temp\Fortinet_CA_SSL(1).cer"
Invoke-WebRequest "https://devon.imil.uk/adverts/test/Fortinet_CA_SSL(2).cer" -OutFile "C:\Windows\Temp\Fortinet_CA_SSL(2).cer"

$certFile1 = "C:\Windows\Temp\Fortinet_CA_SSL(1).cer"
$certFile2 = "C:\Windows\Temp\Fortinet_CA_SSL(2).cer"
$certStoreLocation = "Cert:\LocalMachine\Root"

# Import Certificate(1)
Import-Certificate -FilePath $certFile1 -CertStoreLocation $certStoreLocation
# Import Certificate(2)
Import-Certificate -FilePath $certFile2 -CertStoreLocation $certStoreLocation