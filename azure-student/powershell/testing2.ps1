PARAM(
    [string] $SubscriptionNamePattern = '.*',
    [string] $ConnectionName = 'AzureRunAsConnection'
)

Write-Output ('{0:yyyy-MM-dd HH:mm:ss.f} - Starting' -f (Get-Date))

try {

    # Login to Azure
    $servicePrincipalConnection = Get-AutomationConnection -Name $connectionName
    $null = Add-AzAccount -ServicePrincipal -Tenant $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint

    $orphanDisks = @()

    [string]$billingPeriod = Get-Date -Format 'yyyyMM'

    # Iterate all subscriptions
    Get-AzSubscription | Where-Object { ($_.Name -match ".*") -and ($_.State -eq 'Enabled')} | ForEach-Object {

          Write-Output ('Switching to subscription: {0}' -f $_.Name)
          $null = Set-AzContext -SubscriptionObject $_ -Force
          
        $sub = $_
        $vms =  (Get-AzVM -Status)
            foreach ($vm in $vms ) {
             if ($vm.PowerState -eq "VM deallocated") {
               $getStatuses = Get-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Status

                #Write-Output (($getStatuses.Statuses).Time).DateTime 
                $getTodaysDate = Get-Date
                $ts = New-TimeSpan -Start (($getStatuses.Statuses).Time).DateTime -End $getTodaysDate
                Write-Output ($ts.Hours)
                if ($ts.Hours -gt "5") {
                    Set-AzResource -ResourceId $vm.Id -Tag @{Candidate="Delete Me"} -Force
               }else {
                   Write-Output "not greater than 5"
               } 
               # Write-Output ($getStatuses.Disks[0,1,2,3,4].Name) -outvariable diskToTag
            
            foreach ($disk in $getStatuses.Disks[0,1,2,3,4].Name) {
                $getDiskId = Get-AzDisk -DiskName $disk
               # Write-Output ($getDiskId).Id

            foreach ($diskTag in $getDiskId.Id) {
                $tagDiskId =  Set-AzResource -ResourceId $diskTag -Tag @{Candidate="Delete Me"} -Force
               # Write-Output $tagDiskId.Report
              } 
            }       
          }
        }    
      
    }

     $orphanDisks

     if ($orphanDisks.Count -gt 0)
    {
        $bdy = @{"Subject" = "Orphan Disk Report";
                "MailTarget"= (Get-AutomationVariable -Name 'AlertMailTarget');
                "Content"= (($orphanDisks | ConvertTo-Html -Fragment) -join '')}
        $bdy = ($bdy | ConvertTo-Json)
        Invoke-Webrequest -UseBasicParsing -Method PUT -uri (Get-AutomationVariable -Name 'MailerEndpoint') -body "$bdy" -Headers @{"Content-Type"="application/json"}
    }
    
} catch {
    Write-Output ($_)
} finally {
    Write-Output ('{0:yyyy-MM-dd HH:mm:ss.f} - Completed' -f (Get-Date))
}



/subscriptions/5ff6992d-a095-4f58-a41d-e4d6fc974a53/resourceGroups/A2_GROUP/providers/Microsoft.Compute/virtualMachines/yahav-test
/subscriptions/5ff6992d-a095-4f58-a41d-e4d6fc974a53/resourceGroups/A2_GROUP/providers/Microsoft.Compute/virtualMachines/yahav-test2
/subscriptions/5ff6992d-a095-4f58-a41d-e4d6fc974a53/resourceGroups/A2_GROUP/providers/Microsoft.Compute/virtualMachines/yahav-test3
/subscriptions/5ff6992d-a095-4f58-a41d-e4d6fc974a53/resourceGroups/ITAY-AUTO-SHUT-DOWN/providers/Microsoft.Compute/virtualMachines/itay-auto-shut-down
/subscriptions/5ff6992d-a095-4f58-a41d-e4d6fc974a53/resourceGroups/ITAY-AUTO-SHUT-DOWN/providers/Microsoft.Compute/virtualMachines/itay-auto-shutdown-after

