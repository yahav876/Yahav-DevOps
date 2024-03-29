
PARAM(
    [string] $SubscriptionNamePattern = '.*',
    [string] $ConnectionName = 'AzureRunAsConnection',
    [string] $policyAssignmentId = "",
    [string] $subscriptionName = "",
    [string] $ManagementGroupName = ""
          

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
    # Get-AzSubscription | Where-Object { ($_.Name -match $SubscriptionNamePattern) -and ($_.State -eq 'Enabled') } | ForEach-Object {

        Set-AzContext -SubscriptionName $subscriptionName -Force | Out-Null

        while($(Get-AzPolicyState | Where-Object {$_.PolicyAssignmentId -eq $policyAssignmentId -and $_.ComplianceState -eq "NonCompliant"}))
        {
            $job = Start-AzPolicyRemediation -ManagementGroupName $ManagementGroupName  -PolicyAssignmentId $policyAssignmentId -Name "remediation$(Get-Random)" -AsJob
            $job | Wait-Job
            $remediation = $job | Receive-Job
        }
    
} catch {
    Write-Output ($_)
} finally {
    Write-Output ('{0:yyyy-MM-dd HH:mm:ss.f} - Completed' -f (Get-Date))
}