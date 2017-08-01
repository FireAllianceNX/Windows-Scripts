# WSUSCleanUpTask.ps1
#
# This script is used to cleanup WSUS of old and unused updates.
# Credits goes to http://cm12sdk.net/?p=1543
# This script will need to be added to Scheduled Task on the WSUS server, and it will output the result in an HTML file in D:\WSUSCleanUpLog
# Emailing portion is taken out from original
#
# Created: 2017.03.10, Leon Chung | leonc@nyu.edu

Add-Type -Path "C:\Program Files\Update Services\API\Microsoft.UpdateServices.Administration.dll"

$UseSSL = $False
$PortNumber = 8530
$Server = "Localhost"
$ReportLocation = "D:\WSUSCleanUpLog\WSUS_CleanUpReport $(Get-Date -UFormat %Y%m%d).html"


$WSUSConnection = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer($Server,$UseSSL,$PortNumber)

#Clean Up Scope
$CleanupScopeObject = New-Object Microsoft.UpdateServices.Administration.CleanupScope
   $CleanupScopeObject.CleanupObsoleteComputers = $True
   $CleanupScopeObject.CleanupObsoleteUpdates = $True
   $CleanupScopeObject.CleanupUnneededContentFiles = $True
   $CleanupScopeObject.CompressUpdates = $True
   $CleanupScopeObject.DeclineExpiredUpdates = $True
   $CleanupScopeObject.DeclineSupersededUpdates = $True

$CleanupTASK = $WSUSConnection.GetCleanupManager()

$Results = $CleanupTASK.PerformCleanup($CleanupScopeObject)

   $DObject = New-Object PSObject
       $DObject | Add-Member -MemberType NoteProperty -Name "SupersededUpdatesDeclined" -Value $Results.SupersededUpdatesDeclined
       $DObject | Add-Member -MemberType NoteProperty -Name "ExpiredUpdatesDeclined" -Value $Results.ExpiredUpdatesDeclined
       $DObject | Add-Member -MemberType NoteProperty -Name "ObsoleteUpdatesDeleted" -Value $Results.ObsoleteUpdatesDeleted
       $DObject | Add-Member -MemberType NoteProperty -Name "UpdatesCompressed" -Value $Results.UpdatesCompressed
       $DObject | Add-Member -MemberType NoteProperty -Name "ObsoleteComputersDeleted" -Value $Results.ObsoleteComputersDeleted
       $DObject | Add-Member -MemberType NoteProperty -Name "DiskSpaceFreed" -Value $Results.DiskSpaceFreed

#HTML style
$HeadStyle = "<style>"
$HeadStyle = $HeadStyle + "BODY{background-color:peachpuff;}"
$HeadStyle = $HeadStyle + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$HeadStyle = $HeadStyle + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:thistle}"
$HeadStyle = $HeadStyle + "TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:palegoldenrod}"
$HeadStyle = $HeadStyle + "</style>"

$Date = Get-Date

$DObject | ConvertTo-Html -Head $HeadStyle -Body "<h2>$($ENV:ComputerName) WSUS Report: $date</h2>" | Out-File $ReportLocation
