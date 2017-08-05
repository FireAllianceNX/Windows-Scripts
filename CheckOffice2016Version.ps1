# CheckOffice2016Version.ps1
#
# Loops through machine names and connect to remote registry looking for known registry keys. Checks for CTR or ProPlus.
#
# Author: Leon Chung
# Created: 2017.08.05

$Computers = @("Machine1","Machine2","Machine3")

Foreach ($Computer in $Computers) {
  $Reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $Computer)
  $RegKeyProPlus = $Reg.OpenSubKey("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\Office16.PROPLUS")
  $RegKey365 = $Reg.OpenSubKey("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\O365ProPlusRetail - en-us")
  if (($RegKeyProPlus -eq $null) -and ($RegKey365 -ne $null)) {
    $RegKey = $Reg.OpenSubKey("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\O365ProPlusRetail - en-us")
    $OfficeVersion = $RegKey.GetValue("DisplayVersion")
    $Type = "CTR"
  }
  elseif (($RegKeyProPlus -ne $null) -and ($RegKey365 -eq $null)) {
    $RegKey = $Reg.OpenSubKey("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\Office16.PROPLUS")
    $OfficeVersion = $RegKey.GetValue("DisplayVersion")
    $Type = "MSI"
  }
  else {
    $Type = "no Office installed"
    $OfficeVersion = ""
  }
  Write-Host $Computer has $OfficeVersion $Type
}
