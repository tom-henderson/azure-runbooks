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

$resourceGroup    = 'THX-RG-Network'
$localGatewayName = 'THX-GW-Local'
$hostName = 'thx.no-ip.org'
$localGatewayIP   = [system.net.dns]::GetHostByName($hostName).AddressList.IPAddressToString

Write-Output "Checking IP address of $localGatewayName"

$localGateway = Get-AzureRmLocalNetworkGateway -Name $localGatewayName -ResourceGroupName $resourceGroup
$localAddressSpace = $localGateway.AddressSpaceText | ConvertFrom-Json

if ($localGateway.GatewayIpAddress -ne $localGatewayIP) {
	Write-Output "Gateway IP is $($localGateway.GatewayIpAddress), should be $localGatewayIP"
	$localGateway.GatewayIpAddress = $localGatewayIP
	try {
		Set-AzureRmLocalNetworkGateway -LocalNetworkGateway $localGateway -AddressPrefix @($localAddressSpace.AddressPrefixes)
	} catch {
		Write-Error "Failed to change $localGatewayName gateway IP address to $localGatewayIP"
		Write-Error -Message $_.Exception
		throw $_.Exception
	}
} else {
	Write-Output "Gateway IP is correct: $localGatewayIP"
}