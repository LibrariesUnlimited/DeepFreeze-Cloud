# Update Startup Script to contain new build instructions for all PCs
# Contains the full Startup Script that is included in BuildScript
# If a change is made in the build it should be duplicated here and the powershell script on public PCs will be updated by Maintenance

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

$script | Out-File -FilePath "$path\Startup.ps1" -Encoding ascii