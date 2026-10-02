param(
    [string]$VMName,
    [string]$Role,
    [string]$IP,
    [pscredential]$Credential
)

# Wait for VM

& "C:\LabGPT\Scripts\Wait-VMReady.ps1" `
    -VMName $VMName `
    -Credential $Credential

# Rename

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
