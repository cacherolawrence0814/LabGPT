param (
    [string]$SwitchName,
    [string]$Subnet,
    [string]$Gateway
)

Write-Host "Creating virtual switch $SwitchName..."

#Check if the virtual switch already exists
$switch = get-vmswitch -Name $SwitchName -ErrorAction SilentlyContinue

if ( -not $switch ) {
    New-VMSwitch -Name $SwitchName -SwitchType Internal
    Write-Host "Virtual switch $SwitchName created."
} 
else 
{
    Write-Host "Virtual switch $SwitchName already exists."
}

$AdapterAlias = "vEthernet ($SwitchName)"

# Configure host-side IP
if (-not (Get-NetIPAddress -InterfaceAlias $AdapterAlias -ErrorAction SilentlyContinue))
{
New-NetIPAddress `
-InterfaceAlias $AdapterAlias `
-IPAddress $Gateway `
-PrefixLength 24

Write-Host "Gateway configured."
}
else
    {
        Write-Host "Gateway already configured."
    }

Write-Host "Virtual network ready."