param(
    [string]$VMName,
    [string]$IPAddress,
    [string]$Gateway,
    [string]$DNSservers,
    [pscredential]$Credential
)
$Result = Invoke-Command `
    -VMName $VMName `
    -Credential $Credential `
    -ScriptBlock {

        $Nic = (Get-NetAdapter | Where-Object Status -eq "Up")[0]

        $IP = Get-NetIPAddress `
            -InterfaceAlias $Nic.Name `
            -AddressFamily IPv4 |
            Where-Object {$_.IPAddress -notlike '169.254.*'} |
            Select-Object -First 1

        $DNS = Get-DnsClientServerAddress `
            -InterfaceAlias $Nic.Name `
            -AddressFamily IPv4

        [PSCustomObject]@{
            ComputerName = $env:COMPUTERNAME
            AdapterName  = $Nic.Name
            IPAddress    = $IP.IPAddress
            PrefixLength = $IP.PrefixLength
            DNSServers   = ($DNS.ServerAddresses -join ",")
        }
    }

Write-Host "IP Address: $($Result.IPAddress)"
Write-Host "DNS Server: $($Result.DNSServers)"