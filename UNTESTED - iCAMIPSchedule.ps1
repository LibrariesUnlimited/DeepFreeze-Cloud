# UNTESTED - testing iCAMSiteSpecificIP script as startup 
# also testing deleting startup task as part of script being run by startup task!


$script = @'
$logfile = "C:\Windows\Temp\LogonScript.log"

Write-Output "Script Running" | Out-File -FilePath $logfile -Append

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
    Default 
    {
        Set-ItemProperty -Path $printRegistryPath -Name "Server IP" -Value "99.99.99.99"
        Set-ItemProperty -Path $cafeRegistryPath -Name "Server Address" -Value "99.99.99.99"   
    }
}

Write-Output "Script Finished" | Out-File -FilePath $logfile -Append

Unregister-ScheduledTask -TaskName "IP Startup" -Confirm:$False
'@

$path = "C:\Program Files\Libraries Unlimited"

if(-not(Test-Path $path)) {
    New-Item -path $path -itemType Directory
}

$script | Out-File -FilePath "$path\IPStartup.ps1" -Encoding ascii

$trigger = New-ScheduledTaskTrigger -AtLogOn -User "$env:computername\LUTestUser"
$user = "$env:computername\LUTestUser"
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File ""$path\IPStartup.ps1"""

Register-ScheduledTask -TaskName "IP Startup" -User $user -Trigger $trigger -Action $action