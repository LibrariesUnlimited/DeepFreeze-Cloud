# Create list of printer ports for different printer types (not to be run as script but copied and pasted into non-admin powershell on kiosk)
$pattern = "^(10.0)(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){2}$"
$size = Read-Host "Paper Size: Type either A3 or A4"
$ip = Read-Host "Admin PC public IP address"
if ($ip -notmatch $pattern) {
    Write-Host "Not a valid IP address, run script again"
    Exit
}


switch ($size) {
    A3 
    {
        Add-PrinterPort "\\$ip\A4 Colour"
        Add-PrinterPort "\\$ip\A4 Colour DS"
        Add-PrinterPort "\\$ip\A4 Mono"
        Add-PrinterPort "\\$ip\A4 Mono DS"
        Add-PrinterPort "\\$ip\A3 Colour"
        Add-PrinterPort "\\$ip\A3 Colour DS"
        Add-PrinterPort "\\$ip\A3 Mono"
        Add-PrinterPort "\\$ip\A3 Mono DS"
    }
    A4
    {
        Add-PrinterPort "\\$ip\A4 Colour"
        Add-PrinterPort "\\$ip\A4 Colour DS"
        Add-PrinterPort "\\$ip\A4 Mono"
        Add-PrinterPort "\\$ip\A4 Mono DS"
    }
    Default 
    {
        write-host "Paper Size not entered correctly"
    }
}