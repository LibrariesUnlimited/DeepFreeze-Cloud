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

$registryLocation = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render\"
$audio = Get-ChildItem -Path $registryLocation | ForEach-Object {Get-ItemProperty -Path $_.PsPath | Where-Object {$_.DeviceState -eq 1} | Select-Object PSChildName}

if ($audio.PSChildName -ne $null) {
    Set-EndpointVisibility $audio.PSChildName
}
'@

$path = "C:\Program Files\Libraries Unlimited"

$script | Out-File -FilePath "$path\Audio.ps1" -Encoding ascii

$trigger = New-ScheduledTaskTrigger -AtLogOn -User "$env:computername\LibraryPublicUser"
$user = "$env:computername\LibraryPublicUser"
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File ""$path\Audio.ps1"""

Register-ScheduledTask -TaskName "LU Audio" -User $user -Trigger $trigger -Action $action
