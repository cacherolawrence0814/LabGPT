param(
    [string]$VMName,
    [string]$Domain,
    [pscredential]$Credential,
    [pscredential]$DomainCredential
)

Invoke-Command `
    -VMName $VMName `
    -Credential $Credential `
    -ScriptBlock {

        param($Domain)

        $SafeModePassword = ConvertTo-SecureString `
            "P@ssw0rd" `
            -AsPlainText `
            -Force

        Install-ADDSDomainController `
            -DomainName $Domain `
            -Credential $DomainCredential `
            -InstallDNS `
            -SafeModeAdministratorPassword $SafeModePassword `
            -Force

    } `
    -ArgumentList $Domain