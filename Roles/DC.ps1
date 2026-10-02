param(
    [string]$VMName,
    [pscredential]$Credential
)

Invoke-Command `
    -VMName $VMName `
    -Credential $Credential `
    -ScriptBlock {

        Install-WindowsFeature `
            AD-Domain-Services `
            -IncludeManagementTools

    }