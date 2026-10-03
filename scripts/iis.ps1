### Install IIS ###
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

### Allow HTTP through the Windows firewall ###
New-NetFirewallRule -DisplayName "Allow HTTP 80" -Direction Inbound -Protocol TCP -LocalPort 80 -Action Allow -ErrorAction SilentlyContinue

### Build the page: OS of the server + private IP ###
$os = (Get-CimInstance Win32_OperatingSystem).Caption
$ip = (Get-NetIPAddress -AddressFamily IPv4 |
       Where-Object { $_.IPAddress -like '10.*' } |
       Select-Object -First 1).IPAddress
$computer = $env:COMPUTERNAME

$html = @"
<!DOCTYPE html>
<html>
<head><title>$computer</title></head>
<body style="font-family:Segoe UI,Arial;margin:40px">
  <h1>$os</h1>
  <p>Server name: <b>$computer</b></p>
  <p>Private IP: <b>$ip</b></p>
</body>
</html>
"@

# Default.htm is first in IIS's default-document list, so it wins over iisstart.htm
Set-Content -Path "C:\inetpub\wwwroot\Default.htm" -Value $html -Encoding UTF8
