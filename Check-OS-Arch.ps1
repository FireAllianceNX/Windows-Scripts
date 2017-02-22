# Check-OS-Arch.ps1
#
# Re-useable code to check Windows OS Architecture on Windows 7 and up
#
# Leon Chung
# Created: 2017-02-22

# Get architecture
$OSArch = (Get-WmiObject Win32_OperatingSystem).OSArchitecture

# Do work
if ($OSArch = "64-bit")
  {
    Write-Host "This OS is running 64-bit"
  }
elseif ($OSArch = "32-bit")
  {
    Write-Host "This OS is running 32-bit"
  }
else
  {
    Write-Host "Returned neither 64 or 32 bit"
  }
