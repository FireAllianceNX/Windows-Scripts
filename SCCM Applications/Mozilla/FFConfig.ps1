# FFConfig.ps1
#
# Create preference files for Firefox
# Documentations at https://developer.mozilla.org/en-US/Firefox/Enterprise_deployment
#
# Author: Leon Chung | leonc@nyu.edu
# Created: 2017-06-04
# Modified:
# 2017-07-31 - mozilla.cfg should be in the same directory as firefox.exe
#

# Set your preferences here
$pref = @"
// Disable updater
lockPref("app.update.enabled", false);
// make absolutely sure it is really off
lockPref("app.update.auto", false);
lockPref("app.update.mode", 0);
lockPref("app.update.service.enabled", false);

// Disable the internal PDF viewer because Adobe
pref("pdfjs.disabled", true);
"@

# Tell Firefox where the config file is
$autoconfig = @"
// Any comment. You must start the file with a comment!
pref("general.config.filename", "mozilla.cfg");
pref("general.config.obscure_value", 0);
"@

# We should be using 64-bit Firefox; note that browser folder is post-version 21
$ffpath="${env:ProgramFiles}\Mozilla Firefox"
$prefpath="$ffpath\browser\defaults\preferences"

# Actual work, check for Firefox first
if (Test-Path -Path $ffpath) {
  if (!(Test-Path -Path $prefpath)) {
    New-Item -Path $prefpath -ItemType Directory | Out-Null
    }
  # Create config file about a config file
  $autoconfig | Out-File "$prefpath\autoconfig.js"
  # Create actual config
  $pref | Out-File "$ffpath\mozilla.cfg"
}
