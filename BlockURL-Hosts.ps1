
$urls = @("www.eenadu.net", "www.facebook.com", "www.instagram.com", "www.netflix.com")
$ip = "127.0.0.1"

$hostsPath = "$env:windir\System32\drivers\etc\hosts"

$hostsContent = Get-Content -Path $hostsPath

foreach ($url in $urls) {
  if ($hostsContent -notcontains "$ip`t$url") {
    try {
      Add-Content -Path $hostsPath -Value "$ip`t$url" -ErrorAction Stop
      Write-Host "Successfully added $url to the hosts file."
    }
    catch {
      Write-Host "Failed to add $url to the hosts file. Run the script as administrator." -ForegroundColor Red
    }
  }
  else {
    Write-Host "$url already exists in the hosts file."
  }
}

# Prompt the user for administrative privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  $arguments = "& '" + $MyInvocation.MyCommand.Definition + "'"
  Start-Process powershell.exe -Verb runAs -ArgumentList $arguments
  Exit
}
