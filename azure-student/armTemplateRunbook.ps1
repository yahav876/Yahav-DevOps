PARAM(
    [string] $SubscriptionNamePattern = '.*',
    [string] $ConnectionName = 'AzureRunAsConnection',

)



try {
    # Login to Azure
    $servicePrincipalConnection = Get-AutomationConnection -Name $connectionName
    $null = Add-AzAccount -ServicePrincipal -Tenant $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint
    # Iterate all subscriptions
    Get-AzSubscription | Where-Object { ($_.Name -match $SubscriptionNamePattern) -and ($_.State -eq 'Enabled') } | ForEach-Object {

        $mgmnt = Get-AzManagementGroup
        $armTemplateUrl = "https://raw.githubusercontent.com/yahav876/Yahav-Student/master/azure-student/armTemplate.json"
        $locationMgmnt = "East US"
        $deploymentName = 0
        $deploymentName++

        foreach ( $mgmntId in $mgmnt.Name ) {

            New-AzManagementGroupDeployment `
                -Name "ArmDeployment{0:00#}" -f $deploymentName `
                -Location "$locationMgmnt" `
                -ManagementGroupId "$mgmntId" `
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
