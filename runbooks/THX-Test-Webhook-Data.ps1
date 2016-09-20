workflow THX-Test-WebhookData {
  
  param (
    [object]$WebhookData
  )
  
  # If called from a Webhook, $WebhookData will not be null:
  if ($WebhookData -ne $null) {
    $WebhookName    = $WebhookData.WebhookName
    $WebhookHeaders = $WebhookData.RequestHeader
    $WebhookBody    = ConvertFrom-Json -InputObject $WebhookData.RequestBody
    
    Write-Output "Runbook received Webhook data:"
    Write-Output $WebhookName
    Write-Output $WebhookHeaders
    Write-Output $WebhookBody
  } else {
    Write-Error "Not called from a Webhook."
  }
  
}
