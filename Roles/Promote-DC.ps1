param(
    [string]$VMName,
    [string]$Domain,
    [pscredential]$Credential
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

        Install-ADDSForest `
            -DomainName $Domain `
            -InstallDNS `
            -SafeModeAdministratorPassword $SafeModePassword `
            -Force

    } `
    -ArgumentList $Domain