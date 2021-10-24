
PARAM(
    [string] $SubscriptionNamePattern = '.*',
    [string] $ConnectionName = 'AzureRunAsConnection',
    [String] $ConnectionString = $(Get-AutomationVariable -Name 'CONNECTION_STRING'),
    [String] $BlobContainer = $(Get-AutomationVariable -Name 'BLOB_CONTAINER'),
    
    # Number of days to look backwards.
    [int]    $daysChart = "",
    # Cpu utilization in %
    [int]    $cpuPrecentage = ""
          

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
    $blobStorage.ICloudBlob.AppendText("sub_name,resource_group,resource_name,units,highest_topic/queue_size(KB),cpu_usage(%),memory_usage(%),service_tier,resource_id,location,tags`n")

    Get-AzSubscription | Where-Object { ($_.Name -match ".*") -and ($_.State -eq 'Enabled') } | ForEach-Object {
        $subscriptionName = $_.Name
        Write-Output ('Switching to subscription: {0}' -f $_.Name)
        $null = Set-AzContext -SubscriptionObject $_ -Force

        
        # Set-AzContext -SubscriptionName "Aviad@Energyteam" -Force | Out-Null

        $datenow = Get-Date
        $getServiceBus = Get-AzServiceBusNamespace -WarningAction SilentlyContinue

        foreach ($sbid in $getServiceBus) {

            if (($sbid.Sku.Name -eq "Premium") -and ($sbid.Sku.Capacity -gt 1)) {
                $sizeMetrics = Get-AzMetric -ResourceId $sbid.Id -MetricName "Size" -StartTime $datenow.AddDays($daysChart) -EndTime $datenow -AggregationType "Maximum" -TimeGrain 01:00:00 -WarningAction SilentlyContinue
                $cpuMetrics = Get-AzMetric -ResourceId $sbid.Id -MetricName "NamespaceCpuUsage" -StartTime $datenow.AddDays($daysChart) -EndTime $datenow -AggregationType "Maximum" -TimeGrain 01:00:00 -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
                $memoryMetrics = Get-AzMetric -ResourceId $sbid.Id -MetricName "NamespaceMemoryUsage" -StartTime $datenow.AddDays($daysChart) -EndTime $datenow -AggregationType "Maximum" -TimeGrain 01:00:00 -WarningAction SilentlyContinue -ErrorAction SilentlyContinue

                $cpuPrecent = ($cpuMetrics.Data.Maximum | Sort-Object -Descending | Select-Object -First 1)
                $messageSize = ($sizeMetrics.Data.Maximum | Sort-Object -Descending | Select-Object -First 1) 
                $memoryPrecent = ($memoryMetrics.Data.Maximum | Sort-Object -Descending | Select-Object -First 1) 
                    
                $tags = $sbid.Tags.GetEnumerator() | ForEach-Object { "$($_.Key): $($_.Value)" }

                if (($messageSize / 1000 -lt 256) -or ($cpuPrecent -lt $cpuPrecentage)) {
                    $blobStorage.ICloudBlob.AppendText("$subscriptionName, $($sbid.ResourceGroupName),$($sbid.Name),$($sbid.Sku.Capacity),$($messageSize/1000),$($cpuPrecent),$($memoryPrecent),$($sbid.Sku.Name), $($sbid.Id),$($sbid.Location),$($tags)`n")
                }
            }
            else {
                if ($sbid.Sku.Capacity -eq 1) {
                    $sizeMetrics = Get-AzMetric -ResourceId $sbid.Id -MetricName "Size" -StartTime $datenow.AddDays($daysChart) -EndTime $datenow -AggregationType "Maximum" -TimeGrain 01:00:00 -WarningAction SilentlyContinue
                    $cpuMetrics = Get-AzMetric -ResourceId $sbid.Id -MetricName "NamespaceCpuUsage" -StartTime $datenow.AddDays($daysChart) -EndTime $datenow -AggregationType "Maximum" -TimeGrain 01:00:00 -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
                    $memoryMetrics = Get-AzMetric -ResourceId $sbid.Id -MetricName "NamespaceMemoryUsage" -StartTime $datenow.AddDays($daysChart) -EndTime $datenow -AggregationType "Maximum" -TimeGrain 01:00:00 -WarningAction SilentlyContinue -ErrorAction SilentlyContinue

                    
                    $messageSize = ($sizeMetrics.Data.Maximum | Sort-Object -Descending | Select-Object -First 1)
                    $cpuPrecent = ($cpuMetrics.Data.Maximum | Sort-Object -Descending | Select-Object -First 1)
                    $memoryPrecent = ($memoryMetrics.Data.Maximum | Sort-Object -Descending | Select-Object -First 1) 

                    $tags = $sbid.Tags.GetEnumerator() | ForEach-Object { "$($_.Key): $($_.Value)" }

                    if ($messageSize / 1000 -lt 256) {
                
                        $blobStorage.ICloudBlob.AppendText("$subscriptionName, $($sbid.ResourceGroupName),$($sbid.Name),$($sbid.Sku.Capacity),$($messageSize/1000),$($cpuPrecent),$($memoryPrecent),$($sbid.Sku.Name), $($sbid.Id),$($sbid.Location),$($tags)`n")
    
                    }
            
    
                }
                
            }
        }
    }
            
}
catch {
    Write-Output ($_)
}
finally {
    Write-Output ('{0:yyyy-MM-dd HH:mm:ss.f} - Completed' -f (Get-Date))
}

