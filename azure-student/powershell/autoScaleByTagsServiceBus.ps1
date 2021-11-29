
PARAM(
    [string] $SubscriptionNamePattern = '.*',
    [string] $ConnectionName = 'AzureRunAsConnection',
    [String] $ConnectionString = "DefaultEndpointsProtocol=https;AccountName=cloudshellctigor;AccountKey=NjzBq9pCQqY0Nz5KNbi9uXIg9tYTn6tCtlZY4W3ou22O2e5CUua2Vs46zX1I+y0gbhkmU5svgL2etXdBpk/G+Q==;EndpointSuffix=core.windows.net",
    [String] $BlobContainer = "reports-test",
    # Number of days to look backwards.
    [int]    $daysChart = "14",
    # Cpu utilization in %
    [int]    $cpuPrecentage = "20"
          

)


Write-Output ('{0:yyyy-MM-dd HH:mm:ss.f} - Starting' -f (Get-Date))
try {


    # Login to Azure
    if ($env:AUTOMATION_ASSET_ACCOUNTID) {
        $runAsConnection = Get-AutomationConnection -Name $ConnectionName -ErrorAction Stop
        Add-AzAccount -ServicePrincipal -Tenant $runAsConnection.TenantId -ApplicationId $runAsConnection.ApplicationId `
            -CertificateThumbprint $runAsConnection.CertificateThumbprint -ErrorAction Stop | Out-Null
    }






    Get-AzSubscription | Where-Object { ($_.Name -match ".*") -and ($_.State -eq 'Enabled') } | ForEach-Object {
        $subscriptionName = $_.Name
        Write-Output ('Switching to subscription: {0}' -f $_.Name)
        $null = Set-AzContext -SubscriptionObject $_ -Force


        $getServiceBus = Get-AzServiceBusNamespace -WarningAction SilentlyContinue
        $tableTag = @{'tagName' = 'testing'}

        foreach ($sbid in $getServiceBus) {

            if (($tableTag.Keys -in $sbid.Tags.Keys) -and ($tableTag.Values -in $sbid.Tags.Values)) {
            
                $getAutoScaleSettings = Get-AzAutoscaleSetting -ResourceGroupName $sbid.Id.Split('/')[4] 

                foreach ($autoSettings in $getAutoScaleSettings) {

                    if ($sbid.Id -eq $autoSettings.TargetResourceUri) {

                        

                    }
                    
                }
    
            
            }

        }
