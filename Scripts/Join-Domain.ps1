param(
    [string]$VMName,
    [string]$Domain,
    [pscredential]$LocalCredential,
    [pscredential]$DomainCredential
)

Invoke-Command `
    -VMName $VMName `
    -Credential $LocalCredential `
    -ArgumentList $Domain,$DomainCredential `
    -ScriptBlock {

        param(
            $Domain,
            $Cred
        )
        Write-Host "Joining $VMName to $Domain.."   
        Add-Computer `
            -DomainName $Domain `
            -Credential $Cred `
            -Restart `
            -Force
        Write-Host "Successfully joined $VMName to $Domain." 
    }