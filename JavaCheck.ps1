# Check if Java is installed and if it's greater than Java 7 u 51
# Used in SCCM Global Condition to see if we should install exception.sites
$JavaPath="C:\Program Files*\Java\jre*\bin\java.exe"
$MinVersion=[version]7.0.510.13
If (Test-Path $JavaPath) {
    $JavaVersion=[version](Get-ChildItem "C:\Program Files*\Java\jre*\bin\java.exe").VersionInfo.ProductVersion
    $MaxVersionInstalled=($JavaVersion | Measure-Object -Maximum).maximum
    If ($MaxVersionInstalled -ge $MinVersion) { $true }
    Else { $false }
}
Else { $false }
