param(
    [string]$VMName,
    [string]$Template,
    [string]$SwitchName,
    [int]$MemoryGB = 4
)

$VMFolder = "C:\LabGPT\Labs\$VMName"

#Write-Host "VM Name: $($VM.Name)"
#Write-Host "Template: $($VM.Template)"
#Write-Host "Switch: $($SwitchName)"
#Write-Host "Memory: $($MemoryGB) GB"

New-Item `
    -ItemType Directory `
    -Path $VMFolder `
    -Force | Out-Null

$VHDPath = "$VMFolder\$VMName.vhdx"
#Write-Host "VHD Path: $VHDPath"

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
    -SwitchName $SwitchName

if (Get-VM -Name $VMName -ErrorAction SilentlyContinue)
{
    Write-Host "[SUCCESS] $VMName created."
    Start-VM $VMName
}
else
{
     Write-Host "VM creation failed."
}