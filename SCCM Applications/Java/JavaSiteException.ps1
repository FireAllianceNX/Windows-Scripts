# JavaSiteException.ps1
#
# This script will add 2 servers to the Oracle Java Exception Site List (Per-User)
# If the servers are already in the list, it will exit.
# More servers can be added as needed. The existing server entries can also be set to be
# empty (i.e. site1="") as the script will do a check to see if either site value
# is set to be null.
# Credits: https://derflounder.wordpress.com/2014/01/16/managing-oracles-java-exception-site-list/
#
# Leon Chung | leonc@nyu.edu
# Created: 2017.02.11
# Modified: 2017.05.03 - Re-ordered logic
# 2017.05.08 - Removed always exit 0, added folder detection/creation

# Server addresses - EDIT THESE
$site1 = "http://your.server.com"
$site2 = "https://secure.server.com"

# Actual work - Do not edit below
# Setup path
$SecurityPath="$env:UserProfile\AppData\LocalLow\Sun\Java\Deployment\security\"
$ExceptionPath="$env:UserProfile\AppData\LocalLow\Sun\Java\Deployment\security\exception.sites"

# Make sure that the security folder was created after Java got installed, if not, we can create it.
If (!(Test-Path $SecurityPath)) {
  New-Item $SecurityPath -ItemType directory | Out-Null
}

# If the exception file does not exists, create and add all sites.
# Otherwise check existing sites, if there's no match, append them.
If (!(Test-Path $ExceptionPath)) {
  New-Item -Path $ExceptionPath -ItemType file | Out-Null
  # Run a check in case only one site is needed.
  If ($site1) {
    $site1 >> $ExceptionPath
  }
  If ($site2) {
    $site2 >> $ExceptionPath
  }
}
Else {
  # Sanity check for new line at the end of the file
  $content = Get-Content -Path $ExceptionPath
  If ($content -notmatch '(?<=\r\n)\z') {
    Add-Content -Value ([environment]::newline) -Path $ExceptionPath
  }
  # Check if we are adding anything, look for a match, add if none
  If ($site1) {
    $Site1Check=Get-Content $ExceptionPath | Select-String $site1
    If (!$Site1Check) {
      $site1 >> $ExceptionPath
    }
  }
  If ($site2) {
    $Site2Check=Get-Content $ExceptionPath | Select-String $site2
    If (!($Site2Check)) {
      $site2 >> $ExceptionPath
    }
  }
}
