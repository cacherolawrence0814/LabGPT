param(
    [string]$ConfigFile
)

$Config = Get-Content $ConfigFile | ConvertFrom-Json

Write-Host "Removing $SwitchName..."
Remove-VMSwitch -Name $SwitchName -Force -ErrorAction SilentlyContinue

foreach ($VM in $Config.Machines)
{
    $VMName = $VM.Name

    Write-Host "Removing $VMName..."

    if (Get-VM -Name $VMName -ErrorAction SilentlyContinue)
    {
        Stop-VM -Name $VMName -TurnOff -Force -ErrorAction SilentlyContinue

        Remove-VM `
            -Name $VMName `
            -Force

        Remove-Item `
            "C:\LabGPT\Labs\$VMName" `
            -Recurse `
            -Force `
            -ErrorAction SilentlyContinue
    }
}

Write-Host "Lab destroyed."