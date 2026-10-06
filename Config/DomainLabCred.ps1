$SecurePassword = ConvertTo-SecureString `
    "P@ssw0rd" `
    -AsPlainText `
    -Force

$DomainLabCred = New-Object `
    System.Management.Automation.PSCredential( 
        "test\Administrator",
        $SecurePassword
    )