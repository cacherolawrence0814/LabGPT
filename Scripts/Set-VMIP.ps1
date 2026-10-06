param(
    [string]$VMName,
    [string]$IPAddress,
    [string]$Gateway,
    [string]$DNS = "192.168.100.10",
    [pscredential]$Credential
)

Invoke-Command `
    -VMName $VMName `
    -Credential $Credential `
    -ScriptBlock {

        param($IP,$GW,$DNS)

        $Nic = (Get-NetAdapter | Where-Object Status -eq "Up")[0].Name

        New-NetIPAddress `
            -InterfaceAlias $Nic `
            -IPAddress $IP `
            -PrefixLength 24 `
            -DefaultGateway $GW

        Set-DnsClientServerAddress `
            -InterfaceAlias $Nic `
            -ServerAddresses $DNS

    } `
    -ArgumentList $IPAddress,$Gateway,$DNS