# Remove Built-in Windows 10 Apps
# Credit: http://ccmexec.com/2015/08/removing-built-in-apps-from-windows-10-using-powershell/
#
# Curated for Meredith
# Leon Chung
# 2016.11.03
#

# Variables
# List of apps you want to remove
$AppsList = "Microsoft.MicrosoftOfficeHub","Microsoft.Office.OneNote","Microsoft.Office.Sway","Microsoft.XboxApp","microsoft.windowscommunicationsapps","Microsoft.SkypeApp"


# Actual work
ForEach ($App in $AppsList)
{
  $PackageFullName = (Get-AppxPackage $App).PackageFullName
  $ProPackageFullName = (Get-AppxProvisionedPackage -online | where {$_.Displayname -eq $App}).PackageName
  write-host $PackageFullName
  Write-Host $ProPackageFullName
  if ($PackageFullName)
    {
      Write-Host "Removing Package: $App"
      remove-AppxPackage -package $PackageFullName
    }
  else
    {
      Write-Host "Unable to find package: $App"
    }

  if ($ProPackageFullName)
    {
      Write-Host "Removing Provisioned Package: $ProPackageFullName"
      Remove-AppxProvisionedPackage -online -packagename $ProPackageFullName
    }
  else
    {
      Write-Host "Unable to find provisioned package: $App"
    }
}
