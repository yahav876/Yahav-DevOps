######################################################################################################################

#  Copyright 2021 CloudTeam & CloudHiro Inc. or its affiliates. All Rights Reserved.                                 #

#  You may not use this file except in compliance with the License.                                                  #

#  https://www.cloudhiro.com/AWS/TermsOfUse.php                                                                      #

#  This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES                                                  #

#  OR CONDITIONS OF ANY KIND, express or implied. See the License for the specific language governing permissions    #

#  and limitations under the License.                                                                                #

######################################################################################################################


PARAM(
    [string] $SubscriptionNamePattern = '.*',
    [String]$ConnectionString = $(Get-AutomationVariable -Name 'CONNECTION_STRING'),
    [String]$BlobContainer = $(Get-AutomationVariable -Name 'BLOB_CONTAINER'),
    [string] $ConnectionName = 'AzureRunAsConnection'
)

Write-Output ('{0:yyyy-MM-dd HH:mm:ss.f} - Starting' -f (Get-Date))

try {

    # Login to Azure
    $servicePrincipalConnection = Get-AutomationConnection -Name $connectionName
    $null = Add-AzAccount -ServicePrincipal -Tenant $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint

    # # Initialzie the blob stprage connection using the connection string parameter
    # $blobStorageContext = New-AzStorageContext -ConnectionString $ConnectionString
    # # Get the current time by timezone
    # $currentTime = [System.TimeZoneInfo]::ConvertTimeFromUtc($($(Get-Date).ToUniversalTime()), $([System.TimeZoneInfo]::GetSystemTimeZones() | Where-Object {$_.Id -match "Israel"}))
    # # Creating the name of the CSV file blob
    # $blobName = $("deleted_unattached_disks_$(Get-Date -Date $currentTime -Format 'dd-MM-yyyy_HH:mm:ss').csv")
    # # Craeting the temporary local CSV file
    # New-Item -Name "tempFile.csv" -ItemType File -Force | Out-Null
    # # Copying the the temporary CSV file to the blob storage container as an append blob
    # Set-AzStorageBlobContent -File ".\tempFile.csv" -Blob $blobName -Container $BlobContainer -BlobType Append -Context $blobStorageContext -Force | Out-Null
    # # Get the CSV file blob from the container in the storage account
    # $blobStorage = Get-AzStorageBlob -Blob $blobName -Container $BlobContainer -Context $blobStorageContext
    # # Add the header to the CSV file
    # $blobStorage.ICloudBlob.AppendText("subscription_name,resource_group,location,resource_id,size`n")


    # Iterate all subscriptions
    Get-AzSubscription | Where-Object { ($_.Name -match ".*") -and ($_.State -eq 'Enabled') } | ForEach-Object {

        Write-Output ('Switching to subscription: {0}' -f $_.Name)
        $null = Set-AzContext -SubscriptionObject $_ -Force
          

        $tagname = "Candidate"
        $TagValue = "DeleteMe"
        $taggedResourcesVms = Get-AzResource -ResourceType Microsoft.Compute/virtualMachines -TagName $tagname -TagValue $TagValue
        $taggedResourcesDisks = Get-AzResource -ResourceType Microsoft.Compute/Disks -TagName $tagname -TagValue $TagValue

        
    # # Iterate all Vms with specific tag key 'bla'(replace bla with your key name you want to filter out!)
    #     foreach ( $resource in $taggedResourcesVms) {
    #         if (!$resource.tags.bla) {
    #             Remove-AzResource -ResourceId $resource.Id -Force 
    #             Write-Output('will remove {0} resources' -f $resource.Count) 
                
    #         }
    #     }
    # Iterate all Disks with specific tag key 'bla' (replace bla with your key name you want to filter out!)
        foreach ( $resource in $taggedResourcesDisks) {
            # if (!$resource.tags.Candidate) {
                #Remove-AzResource -ResourceId $resource.Id -Force
                Write-Output($resource.location)
                Write-Output($resource.ResourceGroupName)
                Write-Output($resource.ResourceId)
                Write-Output($resource.tags)
                # Write-Output('will remove {0} resources' -f $resource.Count)
            # }
        }
        
    }
}
    

catch {
    Write-Output ($_)
}
finally {
    Write-Output ('{0:yyyy-MM-dd HH:mm:ss.f} - Completed' -f (Get-Date))
}




