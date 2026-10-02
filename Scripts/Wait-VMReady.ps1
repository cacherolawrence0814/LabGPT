param(
    [string]$VMName,
    [pscredential]$Credential
)

Write-Host "Waiting for $VMName to become available..."

while ($true)
{
    try
    {
        $Result = Invoke-Command `
            -VMName $VMName `
            -Credential $Credential `
            -ScriptBlock {
                "READY"
            } `
            -ErrorAction Stop

        if ($Result -eq "READY")
        {
            Write-Host "$VMName is ready."
            break
        }
    }
    catch
    {
        Write-Host "$VMName not ready yet..."
        Start-Sleep -Seconds 10
    }
}