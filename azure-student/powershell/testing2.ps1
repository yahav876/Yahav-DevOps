PARAM(
    [string] $SubscriptionNamePattern = '.*',
    [string] $ConnectionName = 'AzureRunAsConnection'

)



try {
    # Login to Azure
    $servicePrincipalConnection = Get-AutomationConnection -Name $connectionName
    $null = Add-AzAccount -ServicePrincipal -Tenant $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint
    # Iterate all subscriptions
    Get-AzSubscription | Where-Object { ($_.Name -match $SubscriptionNamePattern) -and ($_.State -eq 'Enabled') } | ForEach-Object {

        $rG = Get-AzResourceGroup
        $armTemplateUrl = "https://raw.githubusercontent.com/yahav876/Yahav-Student/master/azure-student/backupArmTemplate.json"
        $locationMgmnt = "East US"
        $deploymentName = 0
                Write-Output "line22"
        $deploymentName++
    # Deploy a remote ARM template in each Mgmnt group
        foreach ( $rgName in $rG.ResourceGroupName ) {

            New-AzResourceGroupDeployment `
                -Name {"ArmDeployment{0:00#}" -f $deploymentName} `
                -ResourceGroupName $rgName `
                -TemplateUri "$armTemplateUrl"


        }
    


    }

}

catch {
    Write-Output ($_)
}

finally {
    Write-Output ('{0:yyyy-MM-dd HH:mm:ss.f} - Completed' -f (Get-Date))
}