param ( 
    [object]$WebhookData
)


if ($WebhookData -ne $null) {
    $WebhookBody = ConvertFrom-Json -InputObject $WebhookData.RequestBody
    $Message = $WebhookBody.Message
    Write-Output $Message
} else {
    Write-Error "Must be called via webhook."
}
