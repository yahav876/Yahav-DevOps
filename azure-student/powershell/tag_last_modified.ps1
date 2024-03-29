
PARAM(
    [string] $SubscriptionNamePattern = '.*',
    [string] $ConnectionName = 'AzureRunAsConnection',
    # Replace here your endswith username like = .il /.onmicrosoft.com etc.
    [string] $userName = "$*cloudteam.ai"
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


        $vmsResources = Get-AzResource -ResourceType Microsoft.Compute/virtualMachines 
        $disksResources = Get-AzResource -ResourceType Microsoft.Compute/Disks      
       
        Write-Output($resources)
        # Tag resources with last-modified tag by Caller id.
        foreach ($resource in $vmsResources) {
            $users = Get-AzActivityLog -ResourceId $resource.ResourceId -StartTime (Get-Date).AddDays(-14) -EndTime (Get-Date) -WarningAction SilentlyContinue | Select-Object Caller | Where-Object { $_.Caller } | Sort-Object -Property Caller -Unique | Sort-Object -Property Caller -Descending

            if ((!$users) -or ($users.Caller -eq $null)) {
                Write-Output "no logs"
            }
            else {
                foreach ($caller in $users) {
                    if ($caller -match $userName) {
                        Update-AzTag -ResourceId $resource.ResourceId -Tag @{ last_modified_by = $caller.Caller } -Operation Merge
                    }
                
                }
            }
            foreach ($resource in $disksResources) {
                $users = Get-AzActivityLog -ResourceId $resource.ResourceId -StartTime (Get-Date).AddDays(-14) -EndTime (Get-Date) -WarningAction SilentlyContinue | Select-Object Caller | Where-Object { $_.Caller } | Sort-Object -Property Caller -Unique | Sort-Object -Property Caller -Descending
                if ((!$users) -or ($users.Caller -eq $null)) {
                    Write-Output "no logs"
                }
                else {
                    foreach ($caller in $users) {
                        if ($caller -match $userName) {
                            Update-AzTag -ResourceId $resource.ResourceId -Tag @{ last_modified_by = $caller.Caller } -Operation Merge
                        }
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
