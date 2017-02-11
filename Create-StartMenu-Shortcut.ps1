# Create-StartMenu-Shortcut.ps1
#
# Web Apps Shortcut creation
# This will overwrite existing shortcut of the same name
# Credits: http://powershellblogger.com/2016/01/create-shortcuts-lnk-or-url-files-with-powershell/
#
# Leon Chung
# Created: 2016-11-01
# Modified: 2016-12-12 - Added Out-Null to making the directory
# Modified: 2016-12-14 - Fixed for Windows 7 Compatibility

# Check if Shortcut folder exists in the Start Menu if you put them all in a specific folder
$AppsDir = ([System.Environment]::GetFolderPath("CommonApplicationData") + "\Microsoft\Windows\Start Menu\Programs\Web Apps")
If (!(Test-Path $AppsDir)) {
    New-Item -Path $AppsDir -ItemType Directory | Out-Null
}

# Create Shortcut
# In this example, we are pointing the shortcut to open a website with a specific browser
# For icon location, it is relative to $path or somewhere the end-user will be able to access locally
# Comment out any vaules you do not need and vice versa
$Shell = New-Object -ComObject WScript.Shell
$ShortCut = $Shell.CreateShortcut($AppsDir + "\Shortcut.lnk")
$ShortCut.TargetPath="yourexecutable.exe"
$ShortCut.Arguments="-arguementsifrequired"
# $ShortCut.WorkingDirectory = "c:\your\executable\folder\path"; # Don't need this if you use full path for TargetPath
$ShortCut.WindowStyle = 1;
# $ShortCut.Hotkey = "CTRL+SHIFT+F";
# $ShortCut.IconLocation = "yourexecutable.exe, 0"; # Must be accessible to show
$ShortCut.Description = "Your Custom Shortcut Description";
$ShortCut.Save()