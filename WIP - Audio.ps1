# Does not work as permissions aren't correct even though I can do it from RegEdit ... makes no sense

Start-Transcript -Path "C:\Program Files\Libraries Unlimited\AudioTranscript.txt"
Write-Output "Transcript Started"

function Take-Ownership {
    [CmdletBinding(SupportsShouldProcess=$false)]
    Param([Parameter(Mandatory=$true, ValueFromPipeline=$false)] [ValidateNotNullOrEmpty()] [string]$Path,
          [Parameter(Mandatory=$true, ValueFromPipeline=$false)] [ValidateNotNullOrEmpty()] [string]$User,
          [Parameter(Mandatory=$false, ValueFromPipeline=$false)] [switch]$Recurse)
  
    Begin {
      $AdjustTokenPrivileges=@"
  using System;
  using System.Runtime.InteropServices;
  
    public class TokenManipulator {
      [DllImport("kernel32.dll", ExactSpelling = true)]
        internal static extern IntPtr GetCurrentProcess();
  
      [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
        internal static extern bool AdjustTokenPrivileges(IntPtr htok, bool disall, ref TokPriv1Luid newst, int len, IntPtr prev, IntPtr relen);
      [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
        internal static extern bool OpenProcessToken(IntPtr h, int acc, ref IntPtr phtok);
      [DllImport("advapi32.dll", SetLastError = true)]
        internal static extern bool LookupPrivilegeValue(string host, string name, ref long pluid);
  
      [StructLayout(LayoutKind.Sequential, Pack = 1)]
      internal struct TokPriv1Luid {
        public int Count;
        public long Luid;
        public int Attr;
      }
  
      internal const int SE_PRIVILEGE_DISABLED = 0x00000000;
      internal const int SE_PRIVILEGE_ENABLED = 0x00000002;
      internal const int TOKEN_QUERY = 0x00000008;
      internal const int TOKEN_ADJUST_PRIVILEGES = 0x00000020;
  
      public static bool AddPrivilege(string privilege) {
        bool retVal;
        TokPriv1Luid tp;
        IntPtr hproc = GetCurrentProcess();
        IntPtr htok = IntPtr.Zero;
        retVal = OpenProcessToken(hproc, TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, ref htok);
        tp.Count = 1;
        tp.Luid = 0;
        tp.Attr = SE_PRIVILEGE_ENABLED;
        retVal = LookupPrivilegeValue(null, privilege, ref tp.Luid);
        retVal = AdjustTokenPrivileges(htok, false, ref tp, 0, IntPtr.Zero, IntPtr.Zero);
        return retVal;
      }
  
      public static bool RemovePrivilege(string privilege) {
        bool retVal;
        TokPriv1Luid tp;
        IntPtr hproc = GetCurrentProcess();
        IntPtr htok = IntPtr.Zero;
        retVal = OpenProcessToken(hproc, TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, ref htok);
        tp.Count = 1;
        tp.Luid = 0;
        tp.Attr = SE_PRIVILEGE_DISABLED;
        retVal = LookupPrivilegeValue(null, privilege, ref tp.Luid);
        retVal = AdjustTokenPrivileges(htok, false, ref tp, 0, IntPtr.Zero, IntPtr.Zero);
        return retVal;
      }
    }
"@
    }
  
    Process {
      $Item=Get-Item $Path
      Write-Verbose "Giving current process token ownership rights"
      Add-Type $AdjustTokenPrivileges -PassThru > $null
      [void][TokenManipulator]::AddPrivilege("SeTakeOwnershipPrivilege") 
      [void][TokenManipulator]::AddPrivilege("SeRestorePrivilege") 
  
      # Change ownership
      $Account=$User.Split("\")
      if ($Account.Count -eq 1) { $Account+=$Account[0]; $Account[0]=$env:COMPUTERNAME }
      $Owner=New-Object System.Security.Principal.NTAccount($Account[0],$Account[1])
      Write-Verbose "Change ownership to '$($Account[0])\$($Account[1])'"
  
      $Provider=$Item.PSProvider.Name
      if ($Item.PSIsContainer) {
        switch ($Provider) {
          "FileSystem" { $ACL=[System.Security.AccessControl.DirectorySecurity]::new() }
          "Registry"   { $ACL=[System.Security.AccessControl.RegistrySecurity]::new()
                         # Get-Item doesn't open the registry in a way that we can write to it.
                         switch ($Item.Name.Split("\")[0]) {
                           "HKEY_CLASSES_ROOT"   { $rootKey=[Microsoft.Win32.Registry]::ClassesRoot; break }
                           "HKEY_LOCAL_MACHINE"  { $rootKey=[Microsoft.Win32.Registry]::LocalMachine; break }
                           "HKEY_CURRENT_USER"   { $rootKey=[Microsoft.Win32.Registry]::CurrentUser; break }
                           "HKEY_USERS"          { $rootKey=[Microsoft.Win32.Registry]::Users; break }
                           "HKEY_CURRENT_CONFIG" { $rootKey=[Microsoft.Win32.Registry]::CurrentConfig; break }
                         }
                         $Key=$Item.Name.Replace(($Item.Name.Split("\")[0]+"\"),"")
                         $Item=$rootKey.OpenSubKey($Key,[Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree,[System.Security.AccessControl.RegistryRights]::TakeOwnership) }
          default { throw "Unknown provider:  $($Item.PSProvider.Name)" }
        }
        $ACL.SetOwner($Owner)
        Write-Verbose "Setting owner on $Path"
        $Item.SetAccessControl($ACL)
        if ($Provider -eq "Registry") { $Item.Close() }
  
        if ($Recurse.IsPresent) {
          # You can't set ownership on Registry Values
          if ($Provider -eq "Registry") { $Items=Get-ChildItem -Path $Path -Recurse -Force | Where-Object { $_.PSIsContainer } }
          else { $Items=Get-ChildItem -Path $Path -Recurse -Force }
          $Items=@($Items)
          for ($i=0; $i -lt $Items.Count; $i++) {
            switch ($Provider) {
              "FileSystem" { $Item=Get-Item $Items[$i].FullName
                             if ($Item.PSIsContainer) { $ACL=[System.Security.AccessControl.DirectorySecurity]::new() }
                             else { $ACL=[System.Security.AccessControl.FileSecurity]::new() } }
              "Registry"   { $Item=Get-Item $Items[$i].PSPath
                             $ACL=[System.Security.AccessControl.RegistrySecurity]::new()
                             # Get-Item doesn't open the registry in a way that we can write to it.
                             switch ($Item.Name.Split("\")[0]) {
                               "HKEY_CLASSES_ROOT"   { $rootKey=[Microsoft.Win32.Registry]::ClassesRoot; break }
                               "HKEY_LOCAL_MACHINE"  { $rootKey=[Microsoft.Win32.Registry]::LocalMachine; break }
                               "HKEY_CURRENT_USER"   { $rootKey=[Microsoft.Win32.Registry]::CurrentUser; break }
                               "HKEY_USERS"          { $rootKey=[Microsoft.Win32.Registry]::Users; break }
                               "HKEY_CURRENT_CONFIG" { $rootKey=[Microsoft.Win32.Registry]::CurrentConfig; break }
                             }
                             $Key=$Item.Name.Replace(($Item.Name.Split("\")[0]+"\"),"")
                             $Item=$rootKey.OpenSubKey($Key,[Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree,[System.Security.AccessControl.RegistryRights]::TakeOwnership) }
              default { throw "Unknown provider:  $($Item.PSProvider.Name)" }
            }
            $ACL.SetOwner($Owner)
            Write-Verbose "Setting owner on $($Item.Name)"
            $Item.SetAccessControl($ACL)
            if ($Provider -eq "Registry") { $Item.Close() }
          }
        } # Recursion
      }
      else {
        if ($Recurse.IsPresent) { Write-Warning "Object specified is neither a folder nor a registry key.  Recursion is not possible." }
        switch ($Provider) {
          "FileSystem" { $ACL=[System.Security.AccessControl.FileSecurity]::new() }
          "Registry"   { throw "You cannot set ownership on a registry value"  }
          default { throw "Unknown provider:  $($Item.PSProvider.Name)" }
        }
        $ACL.SetOwner($Owner)
        Write-Verbose "Setting owner on $Path"
        $Item.SetAccessControl($ACL)
      }
    }
  }
  
Take-Ownership -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render" -User "NT AUTHORITY\SYSTEM" -Recurse -Verbose

Write-Host "Executing User is"

[System.Security.Principal.WindowsIdentity]::GetCurrent().Name


$registryLocation = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render\"
$audio = Get-ChildItem -Path $registryLocation | ForEach-Object {Get-ItemProperty -Path $_.PsPath | Where-Object {$_.DeviceState -eq 1} | Select-Object PSChildName }

$derivedRegistryLocation = $registryLocation + $audio.PSChildName

$acl = get-acl $derivedRegistryLocation

$idRef = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$regRights = [System.Security.AccessControl.RegistryRights]::FullControl
$InheritanceFlag = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [System.Security.AccessControl.InheritanceFlags]::ObjectInherit
$PropagationFlag = [System.Security.AccessControl.PropagationFlags]::None
$acType = [System.Security.AccessControl.AccessControlType]::Allow
$rule = New-Object System.Security.AccessControl.RegistryAccessRule ($idRef,$regRights,$InheritanceFlag,$PropagationFlag,$acType)
$acl.AddAccessRule($rule)

$acl | Set-Acl -Path $derivedRegistryLocation

Set-ItemProperty -Path $derivedRegistryLocation -Name "DeviceState" -Value 268435457 -Type DWord

Write-Host "trying as local LUTESTUSER"
$username = '.\LUTestUser'
$password = 'FaronicsTest45!'
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($username, $securePassword)

Invoke-Command -ComputerName localhost -Credential $cred -ScriptBlock {
    Set-ItemProperty -Path $derivedRegistryLocation -Name "DeviceState" -Value 268435457 -Type DWord
}

Stop-Transcript