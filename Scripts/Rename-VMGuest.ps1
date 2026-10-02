param(
    [string]$VMName,
    [pscredential]$Credential
)

Invoke-Command `
    -VMName $VMName `
    -Credential $Credential `
    -ScriptBlock {

        param($NewName)

        Rename-Computer `
            -NewName $NewName `
            -Force `
            -Restart

    } `
    -ArgumentList $VMName