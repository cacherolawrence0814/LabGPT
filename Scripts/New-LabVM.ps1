param(
    [string]$VMName,
    [string]$Template,
    [int]$MemoryGB = 4
)

$VMFolder = "C:\LabGPT\Labs\$VMName"

New-Item `
    -ItemType Directory `
    -Path $VMFolder `
    -Force | Out-Null

$VHDPath = "$VMFolder\$VMName.vhdx"

Copy-Item `
    -Path $Template `
    -Destination $VHDPath `
    -Force

$MemoryBytes = $MemoryGB * 1GB

New-VM `
    -Name $VMName `
    -Generation 2 `
    -MemoryStartupBytes $MemoryBytes `
    -VHDPath $VHDPath `
    -SwitchName "Test Switch"

Start-VM $VMName

Write-Host "[SUCCESS] $VMName created."