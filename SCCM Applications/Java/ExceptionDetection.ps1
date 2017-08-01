# Detection Method to check if exception.sites was updated with our script

$OurPath="$env:USERPROFILE\AppData\LocalLow\Sun\Java\Deployment\security\exception.sites"
If (Test-Path $OurPath) {
  $OurFile=Get-ChildItem $OurPath
  $filedate=$OurFile.LastWriteTime
  $deploydate=Get-Date -Year 2017 -Month 5 -Day 4 -Hour 12 -Minute 40
  if ($filedate -ge $deploydate) {
    Write-Host "Installed"
    exit 0
  }
  Else {
    exit 0
  }
}
Else {
  exit 0
}
