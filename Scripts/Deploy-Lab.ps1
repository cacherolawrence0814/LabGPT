param(
    [string]$ConfigFile
)

Write-Host ""
Write-Host "================================="
Write-Host "LabGPT Deployment Starting..."
Write-Host "================================="
Write-Host ""

# Load Credentials
. "C:\LabGPT\Config\LabCred.ps1"

# Load Config
$Config = Get-Content $ConfigFile | ConvertFrom-Json

#Create Virtual Network
& "C:\LabGPT\Scripts\Create-Vnet.ps1" `
    -SwitchName $Config.Network.SwitchName `
    -Subnet $Config.Network.Subnet `
    -Gateway $Config.Network.Gateway

foreach ($VM in $Config.Machines)
{
    Write-Host ""
    Write-Host "Deploying $($VM.Name)..."
    Write-Host ""

    #
    # STEP 1 - CREATE VM
    #
    & "C:\LabGPT\Scripts\New-LabVM.ps1" `
        -VMName $VM.Name `
        -Template "C:\LabGPT\Templates\$($VM.Template)" `
        -MemoryGB $VM.Memory `
        -SwitchName $Config.Network.SwitchName

    #
    # STEP 2 - WAIT FOR BOOT
    #
    & "C:\LabGPT\Scripts\Wait-VMReady.ps1" `
        -VMName $VM.Name `
        -Credential $LabCred

    #
    # STEP 3 - RENAME GUEST
    #
    & "C:\LabGPT\Scripts\Rename-VMGuest.ps1" `
        -VMName $VM.Name `
        -Credential $LabCred
    #
    # STEP 4 - WAIT FOR FIRST REBOOT
    #
    & "C:\LabGPT\Scripts\Wait-VMOffline.ps1" `
    -VMName $VM.Name `
    -Credential $LabCred

    #
    # STEP 5 - WAIT AFTER REBOOT
    #
    & "C:\LabGPT\Scripts\Wait-VMReady.ps1" `
        -VMName $VM.Name `
        -Credential $LabCred

    #
    # STEP 6 - ASSIGN IP
    #
    if ($VM.IP)
    {
        & "C:\LabGPT\Scripts\Set-VMIP.ps1" `
            -VMName $VM.Name `
            -IPAddress $VM.IP `
            -Credential $LabCred
    }
    #
    # STEP 7 - ASSIGN ROLE
    #
    switch($VM.Role)
    {
     "DC"
      {
        & "C:\LabGPT\Roles\DC.ps1" `
            -VMName $VM.Name `
            -Credential $LabCred
            #
            # STEP 7.1 - PROMOTE DC
            #
            & "C:\LabGPT\Roles\Promote-DC.ps1" `
                -VMName $VM.Name `
                -Domain $Config.Domain `
                -Credential $LabCred
            # Load Credentials
            #   . "C:\LabGPT\Config\DomainLabCred.ps1"            
            #
            # STEP 7.2 - WAIT AFTER REBOOT
            #
           # & "C:\LabGPT\Scripts\Wait-VMReady.ps1" `
            #     -VMName $VM.Name `
              #   -Credential $DomainLabCred
    }

    "CLIENT"
    {
        & "C:\LabGPT\Roles\CLIENT.ps1" `
            -VMName $VM.Name `
            -Credential $LabCred
        & "C:\LabGPT\Scripts\Join-Domain.ps1" `
            -VMName $VM.Name `
            -Domain $Config.Domain `
            -LocalCredential $LabCred `
            -DomainCredential $DomainLabCred
    }

    "WDS"
    {
        & "C:\LabGPT\Roles\WDS.ps1" `
            -VMName $VM.Name `
            -Credential $LabCred
        & "C:\LabGPT\Scripts\Join-Domain.ps1" `
            -VMName $VM.Name `
            -Domain $Config.Domain `
            -LocalCredential $LabCred `
            -DomainCredential $DomainLabCred
    }

    "APP"
    {
        & "C:\LabGPT\Roles\APP.ps1" `
            -VMName $VM.Name `
            -Credential $LabCred
        & "C:\LabGPT\Scripts\Join-Domain.ps1" `
            -VMName $VM.Name `
            -Domain $Config.Domain `
            -LocalCredential $LabCred `
            -DomainCredential $DomainLabCred
    }
}

    Write-Host ""
    Write-Host "$($VM.Name) completed."
    Write-Host ""
}


Write-Host ""
Write-Host "================================="
Write-Host "Lab Deployment Completed"
Write-Host "================================="
Write-Host ""