param(
    [string]$VMName,
    [pscredential]$Credential,
    [string]$DNSIP = "127.0.0.1"
)

Invoke-Command `
    -VMName $VMName `
    -Credential $Credential `
    -ScriptBlock {

        param($DNS)

        $Nic = (Get-NetAdapter | Where-Object Status -eq "Up")[0].Name

        Install-WindowsFeature `
            AD-Domain-Services `
            -IncludeManagementTools
        Set-DnsClientServerAddress `
            -InterfaceAlias $Nic `
            -ServerAddresses $DNS

    } `
    -ArgumentList $DNSIP