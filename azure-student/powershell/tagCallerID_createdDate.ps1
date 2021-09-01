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
    [string] $ConnectionName = 'AzureRunAsConnection'
)


Write-Output ('{0:yyyy-MM-dd HH:mm:ss.f} - Starting' -f (Get-Date))

try {
    # Login to Azure
    if ($env:AUTOMATION_ASSET_ACCOUNTID) {
        $runAsConnection = Get-AutomationConnection -Name $ConnectionName -ErrorAction Stop
        Add-AzAccount -ServicePrincipal -Tenant $runAsConnection.TenantId -ApplicationId $runAsConnection.ApplicationId `
            -CertificateThumbprint $runAsConnection.CertificateThumbprint -ErrorAction Stop | Out-Null
    }
    # Iterate all subscriptions
    Get-AzSubscription | Where-Object { ($_.Name -match $SubscriptionNamePattern) -and ($_.State -eq 'Enabled') } | ForEach-Object {

        Write-Output ('Switching to subscription: {0}' -f $_.Name)
        $null = Set-AzContext -SubscriptionObject $_ -Force


        $resourceWithTag = Get-AzResource -Tag @{ environment = "None" }
        

        # Tag resources with date created
        # Tag each resource with tag name 'created_By = None' with his CallerID'
        foreach ($resource in $resourceWithTag) {
            $logEntries = Get-AzLog -StartTime (Get-Date).AddDays(-90) -ResourceId $resource.ResourceId | Sort-Object -Property SubmissionTimestamp
            $users = Get-AzLog -ResourceId $resource.ResourceId -StartTime (Get-Date).AddDays(-90) -EndTime (Get-Date)| Select-Object Caller | Where-Object { $_.Caller } | Sort-Object -Property Caller -Unique | Sort-Object -Property Caller -Descending
            if ((!$logEntries) -or ($logEntries.SubmissionTimestamp -eq $null)) {
                Write-Output "no logs"
            }
            else {
            Update-AzTag -ResourceId $resource.ResourceId -Tag @{ created_By = $users[0].Caller.Split('@')[0]} -Operation Merge
            Update-AzTag -ResourceId $resource.ResourceId -Tag @{ created_On_Date = $logEntries[0].SubmissionTimestamp } -Operation Merge
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
