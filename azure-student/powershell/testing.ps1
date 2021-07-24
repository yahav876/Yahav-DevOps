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
    Get-AzSubscription | Where-Object { ($_.Name -match ".*") -and ($_.State -eq 'Enabled') } | ForEach-Object {

        Write-Output ('Switching to subscription: {0}' -f $_.Name)
        $null = Set-AzContext -SubscriptionObject $_ -Force
        $sub = $_
        Get-AzAutomationVariable -Name getVmStatus -ResourceGroupName a2_group -AutomationAccountName aviad-auto
        Write-Output $getVmStatus      
        # Get Stopped/Deallocated Vms More Than 90 Days & DiskSize Over 50GB & Tag Them
        $ids = New-Object System.Collections.ArrayList
        $mergedTags = @{"Candidate" = "DeleteMe" }
        $vms = (Get-AzVM -Status)
        foreach ($vm in $vms ) {
            $getAzlog
            $getStatuses = Get-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Status  
            $getCurrentDate = Get-Date  
            [bool]$flag = 0
            if ($vm.PowerState -eq "VM deallocated") {
                $logEntry = (Get-AzLog  -ResourceId $vm.Id -Status Accepted -DetailedOutput  | Where-Object { $_.Authorization.Action -eq "Microsoft.Compute/virtualMachines/deallocate/action" })
                if ($logEntry -eq "null") {
                    Update-AzTag -ResourceId $vm.Id -Tag $mergedTags -Operation Merge 
                    $ts = New-TimeSpan  -Start ($logEntry[0].EventTimestamp) -End $getCurrentDate
                    if ($ts.Days -gt 89) { 
                        $ids.Add($vm.Id)
                        foreach ($disk in $getStatuses.Disks.Name) {
                            $diskSize = Get-AzDisk -ResourceGroupName $vm.ResourceGroupName -Name $disk
                            if ($diskSize.DiskSizeGB -gt 50) {
                                $flag = 1
                                $ids.Add($diskSize.Id)
                                if ($flag = 1) {
                                    Update-AzTag -ResourceId $vm.Id -Tag $mergedTags -Operation Merge
                                    Update-AzTag -ResourceId $diskSize.Id -Tag $mergedTags -Operation Merge
                                }
                            }
                        }
                    }
                }
            }         
        }
    
    
          
            
        $orphanDisks

        if ($orphanDisks.Count -gt 0) {
            $bdy = @{"Subject" = "Orphan Disk Report";
                "MailTarget"   = (Get-AutomationVariable -Name 'AlertMailTarget');
                "Content"      = (($orphanDisks | ConvertTo-Html -Fragment) -join '')
            }
            $bdy = ($bdy | ConvertTo-Json)
            Invoke-Webrequest -UseBasicParsing -Method PUT -uri (Get-AutomationVariable -Name 'MailerEndpoint') -body "$bdy" -Headers @{"Content-Type" = "application/json" }
        }
    
    }
    catch {
        Write-Output ($_)
    }
    finally {
        Write-Output ('{0:yyyy-MM-dd HH:mm:ss.f} - Completed' -f (Get-Date))
    }

