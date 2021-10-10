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
    [string] $ConnectionName = 'AzureRunAsConnection',
    [string] $policyAssignmentId = "/providers/Microsoft.Management/managementGroups/m1/providers/Microsoft.Authorization/policyAssignments/3e6a78ad6e40450eb5dbd3f4",
    [string] $policyAssignmentIdsql = "",
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
    $blobName = $("hybrid_benefit_data_$(Get-Date -Date $currentTime -Format 'dd-MM-yyyy_HH:mm:ss').csv")
    # Craeting the temporary local CSV file
    New-Item -Name "tempFile.csv" -ItemType File -Force | Out-Null
    # Copying the the temporary CSV file to the blob storage container as an append blob
    Set-AzStorageBlobContent -File ".\tempFile.csv" -Blob $blobName -Container $BlobContainer -BlobType Append -Context $blobStorageContext -Force | Out-Null
    # Get the CSV file blob from the container in the storage account
    $blobStorage = Get-AzStorageBlob -Blob $blobName -Container $BlobContainer -Context $blobStorageContext
    # Add the header to the CSV file
    $blobStorage.ICloudBlob.AppendText("resource_name,subscription_name,resource_group,location,resource_id,size,tags`n")

    Get-AzSubscription | Where-Object { ($_.Name -match ".*") -and ($_.State -eq 'Enabled') } | ForEach-Object {
        $subscriptionName = $_.Name
        Write-Output ('Switching to subscription: {0}' -f $_.Name)
        $null = Set-AzContext -SubscriptionObject $_ -Force

        
    # Set-AzContext -SubscriptionName $subscriptionName -Force | Out-Null

    # $policyDataVM = Get-AzPolicyState | Where-Object {$_.PolicyAssignmentId -eq $policyAssignmentId -and $_.ComplianceState -eq "NonCompliant"}
    $Na = ""
    $policyDataVM = Get-AzPolicyState -Filter "PolicyAssignmentId eq '$($policyAssignmentId)' and ComplianceState eq 'NonCompliant'"
    
    foreach ($resource in $policyDataVM) {

        # Get information needed for further proccess.
        $getResourceInfo = Get-AzResource -ResourceId $resource.ResourceId

        # Create a tags variable to be able insert it in CSV.
        $tags = $getResourceInfo.Tags.GetEnumerator() | ForEach-Object {"$($_.Key): $($_.Value)"} 

        # Get VM size 
        $vmSize = Get-AzVM -ResourceGroupName $resource.ResourceGroup -Name $getResourceInfo.Name

        # Write information about NonCompliant VMs in CSV.
        $blobStorage.ICloudBlob.AppendText("$($getResourceInfo.Name) ,$subscriptionName, $($resource.ResourceGroup), $($resource.ResourceLocation), $($resource.ResourceId), $($vmSize.HardwareProfile.VmSize), $($tags)`n")

        }

    $policyDataSQL = Get-AzPolicyState | Where-Object {$_.PolicyAssignmentId -eq $policyAssignmentIdsql -and $_.ComplianceState -eq "NonCompliant"}
    
    foreach ($resource in $policyDataSQL) {
    
        # Get information needed for further proccess.
        $getResourceInfo = Get-AzResource -ResourceId $resource.ResourceId
        
        # Create a tags variable to be able insert it in CSV.
        $tags = $getResourceInfo.Tags.GetEnumerator() | ForEach-Object {"$($_.Key): $($_.Value)"}

        # Write information about NonCompliant VMs in CSV.
        $blobStorage.ICloudBlob.AppendText("$($getResourceInfo.Name) ,$subscriptionName, $($resource.ResourceGroup), $($resource.ResourceLocation), $($resource.ResourceId),$($Na) ,$($tags)`n")

        }
    }
} catch {
    Write-Output ($_)
} finally {
    Write-Output ('{0:yyyy-MM-dd HH:mm:ss.f} - Completed' -f (Get-Date))
}