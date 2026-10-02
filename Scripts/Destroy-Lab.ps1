param(
    [string]$ConfigFile
)

$Config = Get-Content $ConfigFile | ConvertFrom-Json

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