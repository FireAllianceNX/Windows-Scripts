# IPBasedCollection.ps1
# Author  : Leon Chung
# Credits : www.SystemCenterDudes.com
# Based On: Operational Collection.ps1
#
# Created : 2017.02.03
# Modified:
# 2017.02.03 - Initial Script
# 2017.07.31 - Use a loop instead of referring to collections variable in every
#    stage of the creation.
#
# Purpose : This script create a set of SCCM collections based on
#  IP Subnet and move it to "IP Based" folder
#

# Edit these for sure
# List of Collections Query
$Collection1 = @{Name = "My-LAN"; Query = "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from SMS_R_System where SMS_R_System.IPSubnets = '10.1.0.0'"}
$Collection2 = @{Name = "My-Wireless"; Query = "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from SMS_R_System where SMS_R_System.IPSubnets = '10.2.0.0'"}
$Collection3 = @{Name = "My-OtherLAN"; Query = "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from SMS_R_System where SMS_R_System.IPSubnets = '10.3.0.0'"}

# Collection Array - Add new collection to this if you added more above
$Collections = $Collection1, $Collection2, $Collection3

# Only edit the Schedule interval after this section if you want to
# Load Configuration Manager PowerShell Module
Import-module ($Env:SMS_ADMIN_UI_PATH.Substring(0,$Env:SMS_ADMIN_UI_PATH.Length-5) + '\ConfigurationManager.psd1')

#Get SiteCode
$SiteCode = Get-PSDrive -PSProvider CMSITE
Set-location $SiteCode":"

#Error Handling and output
Clear-Host
$ErrorActionPreference= 'SilentlyContinue'
$Error1 = 0

# Refresh Schedule - EDIT ME IF YOU DON'T WANT DAILY REFRESH
$Schedule = New-CMSchedule –RecurInterval Days –RecurCount 1

#Create Defaut Folder
$CollectionFolder = @{Name = "IP Based"; ObjectType = 5000; ParentContainerNodeId = 0}
Set-WmiInstance -Namespace "root\sms\site_$($SiteCode.Name)" -Class "SMS_ObjectContainerNode" -Arguments $CollectionFolder

#Create Default limiting collections
$LimitingCollection = "All Systems"

#Create Collection
Foreach ($Collection in $Collections)
{
  try{
    Write-Host Attempting to create $Collection.Name Collection
    New-CMDeviceCollection -Name $Collection.Name -LimitingCollectionName $LimitingCollection -RefreshSchedule $Schedule -RefreshType Both | Out-Null
    Add-CMDeviceCollectionQueryMembershipRule -CollectionName $Collection.Name -QueryExpression $Collection.Query -RuleName $Collection.Name

    #Move the collection to the right folder
    $FolderPath = $SiteCode.Name + ":\DeviceCollection\" + $CollectionFolder.Name
    Move-CMObject -FolderPath $FolderPath -InputObject (Get-CMDeviceCollection -Name $Collection.Name)
  }
  catch{
    $Error1 = 1
  }
  Finally{
    If ($Error1 -eq 1){
      Write-host "-----------------"
      Write-host -ForegroundColor Red "Script has already been run or $($Collection.Name) already exist. Delete it and re-run the script!"
      Write-host "-----------------"
      Pause
    }
    Else{
      Write-host "-----------------"
      Write-Host -ForegroundColor Green "$($Collection.Name) Collection created sucessfully"
      Write-host "-----------------"

    }
  }
}
