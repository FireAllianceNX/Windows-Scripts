$AppPath="C:\Program Files\R\R-*\bin\R.exe"
$MinVersion=[version]"2.11.1"
If (Test-Path $AppPath) {
  $InstalledVersions=(Get-ChildItem $AppPath).VersionInfo.FileVersion
  # Sanitize version because they added a date in the version
  foreach($line in $InstalledVersions) {
    $s = $line.split()
    $ver = $s[0]
  }
  $MaxVersionInstalled=([version]$ver | Measure-Object -Maximum).maximum
  If ($MaxVersionInstalled -ge $MinVersion) { Write-Host "Installed" }
  Else {  }
}
Else {  }
