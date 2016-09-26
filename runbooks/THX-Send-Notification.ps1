param ( 
    [object]$WebhookData
)

if ($WebhookData -ne $null) {
    $WebhookBody = ConvertFrom-Json -InputObject $WebhookData.RequestBody
    $Message = $WebhookBody.Message
    $Endpoint = Get-AutomationVariable -Name 'IFTTT-NotificationURL'
    Write-Output $Message
    Write-Output $Endpoint

    $body = @{
        value1 = $Message
    }

    Invoke-RestMethod -Method Post -Uri $Endpoint -Body (ConvertTo-Json $body) -Header @{"Content-Type"="application/json"}
} else {
    Write-Error "Must be called via webhook."
}
