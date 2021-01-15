# SetDNS.ps1
# Change static DNS on Windows
#
# Update DNSArray and the IPAddress to search for in the range of servers you are updating
# You'll need a list of server names in a file named Servers.txt
#
# Author: Leon Chung
# Date: 2020-06-30
# Modified: 2020-07-10 - Use different methods in Windows 2008 R2 and/or PowerShell 2.0


$Creds = Get-Credential -Message "Enter Admin Credentials"

function SetDNS {
  [version]$OSVersion = (Get-CimInstance Win32_OperatingSystem).version
  $DNSArray = "10.0.0.1","10.0.0.2","10.225.0.1" # The DNS IPs you want to change to
  $SubnetFilter = "10.10.*" # Used to get the right network interface to change

  if ($OSVersion -ge [version]'6.2.0') {
    [array]$NetIndex = (Get-NetIPAddress -IPAddress $SubnetFilter).InterfaceIndex
    ForEach ($nindex in $NetIndex) {
      Set-DnsClientServerAddress -InterfaceIndex $nindex -ServerAddresses ($DNSArray)
    }
  }
  else {
    if ($PSVersionTable.PSVersion.Major -ge 3) {
      $NetInterface = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled = $true and DHCPEnabled = $false" | Where-Object IPAddress -Like $SubnetFilter
      ForEach ($adapter in $NetInterface) {
        $adapter | Invoke-CimMethod -MethodName SetDNSServerSearchOrder -Arguments @{DNSServerSearchOrder = $DNSArray}
      }
    }
    else {
      $NetInterface = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled = $true and DHCPEnabled = $false" | Where-Object {$_.IPAddress -like "$SubnetFilter"}
      ForEach ($adapter in $NetInterface) {
        $adapter | Invoke-WmiMethod -Name SetDNSServerSearchOrder -ArgumentList (,$DNSArray)
      }
    }
  }
}


ForEach ($Server in (Get-Content Servers.txt)) {

  try {
    $Session = New-PSSession -ComputerName $Server -Credential $Creds -ErrorAction Stop
    Write-Host "Connected to $Server"
    Invoke-Command -Session $Session -ScriptBlock ${Function:SetDNS}
  }
  catch {
    Write-Host "Failed to connect to $Server"
  }

}
