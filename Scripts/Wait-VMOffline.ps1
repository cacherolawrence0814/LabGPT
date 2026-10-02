param(
    [string]$VMName,
    [pscredential]$Credential
)

Write-Host "Waiting for $VMName to reboot..."

while ($true)
{
    try
    {
        Invoke-Command `
            -VMName $VMName `
            -Credential $Credential `
            -ScriptBlock { "TEST" } `
            -ErrorAction Stop

        Start-Sleep 5
    }
    catch
    {
        Write-Host "$VMName is rebooting."
        break
    }
}