param ( 
    [object]$WebhookData
)

$connectionName = "AzureRunAsConnection"
try {
    # Get the connection "AzureRunAsConnection"
    $servicePrincipalConnection = Get-AutomationConnection -Name $connectionName         

    Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
} catch {
    if (!$servicePrincipalConnection) {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else {
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}

if ($WebhookData -ne $null) {
    $WebhookBody = ConvertFrom-Json -InputObject $WebhookData.RequestBody
    $Message = $WebhookBody.Message
    $Endpoint = Get-AzureAutomationVariable -AutomationAccountName "THX-Automation" -Name "IFTTT-NotificationURL"
    Write-Output $Message
    Write-Output $Endpoint.value
} else {
    Write-Error "Must be called via webhook."
}
