'Change strBIOSUpdateVersion to the version you are deploying to
strBIOSUpdateVersion = "A05"

'Get BIOS Version from Win32_BIOS
Set objWMI = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
Set colBIOS = objWMI.ExecQuery("Select * from Win32_BIOS")
For Each objBIOS In colBIOS
  If objBIOS.SMBIOSBIOSVersion >= strBIOSUpdateVersion Then
  WScript.Echo "Detected"
End If
Next
