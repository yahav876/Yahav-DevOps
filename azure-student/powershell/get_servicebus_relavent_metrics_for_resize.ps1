
PARAM(
    [string] $SubscriptionNamePattern = '.*',
    [string] $ConnectionName = 'AzureRunAsConnection',
    [String] $ConnectionString = $(Get-AutomationVariable -Name 'CONNECTION_STRING'),
    [String] $BlobContainer = $(Get-AutomationVariable -Name 'BLOB_CONTAINER')
          

)


Write-Output ('{0:yyyy-MM-dd HH:mm:ss.f} - Starting' -f (Get-Date))

try {


    # Login to Azure
    if ($env:AUTOMATION_ASSET_ACCOUNTID) {
        $runAsConnection = Get-AutomationConnection -Name $ConnectionName -ErrorAction Stop
        Add-AzAccount -ServicePrincipal -Tenant $runAsConnection.TenantId -ApplicationId $runAsConnection.ApplicationId `
            -CertificateThumbprint $runAsConnection.CertificateThumbprint -ErrorAction Stop | Out-Null
    }

    # Initialzie the blob stprage connection using the connection string parameter
    $blobStorageContext = New-AzStorageContext -ConnectionString $ConnectionString
    # Get the current time by timezone
    $currentTime = [System.TimeZoneInfo]::ConvertTimeFromUtc($($(Get-Date).ToUniversalTime()), $([System.TimeZoneInfo]::GetSystemTimeZones() | Where-Object {$_.Id -match "Israel"}))
    # Creating the name of the CSV file blob
    $blobName = $("service_bus_data_$(Get-Date -Date $currentTime -Format 'dd-MM-yyyy_HH:mm:ss').csv")
    # Craeting the temporary local CSV file
    New-Item -Name "tempFile.csv" -ItemType File -Force | Out-Null
    # Copying the the temporary CSV file to the blob storage container as an append blob
    Set-AzStorageBlobContent -File ".\tempFile.csv" -Blob $blobName -Container $BlobContainer -BlobType Append -Context $blobStorageContext -Force | Out-Null
    # Get the CSV file blob from the container in the storage account
    $blobStorage = Get-AzStorageBlob -Blob $blobName -Container $BlobContainer -Context $blobStorageContext
    # Add the header to the CSV file
    $blobStorage.ICloudBlob.AppendText("sub_name,resource_group,resource_name,service_tier,resource_id,location,tags`n")

    Get-AzSubscription | Where-Object { ($_.Name -match ".*") -and ($_.State -eq 'Enabled') } | ForEach-Object {
        $subscriptionName = $_.Name
        Write-Output ('Switching to subscription: {0}' -f $_.Name)
        $null = Set-AzContext -SubscriptionObject $_ -Force

        
        # Set-AzContext -SubscriptionName "Aviad@Energyteam" -Force | Out-Null

        $datenow = Get-Date
        $getServiceBus = Get-AzServiceBusNamespace
        $max = 0    
        # $sbids = New-Object System.Collections.ArrayList

        foreach ($sbid in $getServiceBus) {
            $sizeMetrics = Get-AzMetric -ResourceId $sbid.Id -MetricName "Size" -StartTime $datenow.AddDays(-30) -EndTime $datenow -AggregationType "Maximum" -TimeGrain 01:00:00 

            foreach ($metric in $sizeMetrics.Data.Maximum) {
            
                if ($metric -gt $max) {
                    $max = $metric
                    # Write-Output $max
                    if (($max/1000) -lt 256) {
                        # Write-Output "less than 256"
                        $tags = $sbid.Tags.GetEnumerator() | ForEach-Object {"$($_.Key): $($_.Value)"}
                        $blobStorage.ICloudBlob.AppendText("$subscriptionName, $($sbid.ResourceGroupName),$($sbid.Name),$($sbid.Sku.Name), $($sbid.Id),$($sbid.Location),$($tags)`n")
                    } 
                } 
            }
            $cpuMetrics =  Get-AzMetric -ResourceId $sbid.Id -MetricName "NamespaceCpuUsage" -StartTime $datenow.AddDays(-30) -EndTime $datenow -AggregationType "Maximum" -TimeGrain 01:00:00

            foreach ($metric in $cpuMetrics) {

                if ($metric.Data.Maximum -lt 20) {
                    # Write-Output("Need to scale units down $($metric.Name)")
                    $tags = $sbid.Tags.GetEnumerator() | ForEach-Object {"$($_.Key): $($_.Value)"}
                    $blobStorage.ICloudBlob.AppendText("$subscriptionName, $($sbid.ResourceGroupName),$($sbid.Name),$($sbid.Sku.Name), $($sbid.Id),$($sbid.Location),$($tags)`n")

                }
                
            }
        }
    
    }
    
    Write-Output "Maximum Message size is $($max/1000)KB For service bus 1"

}
catch {
    Write-Output ($_)
}
finally {
    Write-Output ('{0:yyyy-MM-dd HH:mm:ss.f} - Completed' -f (Get-Date))
}

