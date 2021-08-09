#!/usr/bin/env python3

######################################################################################################################

#  Copyright 2021 CloudTeam & CloudHiro Inc. or its affiliates. All Rights Reserved.                                 #

#  You may not use this file except in compliance with the License.                                                  #

#  https://www.cloudhiro.com/AWS/TermsOfUse.php                                                                      #

#  This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES                                                  #

#  OR CONDITIONS OF ANY KIND, express or implied. See the License for the specific language governing permissions    #

#  and limitations under the License.                                                                                #

######################################################################################################################

# Import module dependencies
from typing import List
from azure.mgmt import resource
from azure.mgmt import compute
from azure.mgmt.monitor import MonitorManagementClient
from azure.mgmt.resource import SubscriptionClient, subscriptions
from azure.mgmt.resource import ResourceManagementClient
from azure.mgmt.compute import ComputeManagementClient
import datetime
import csv
from datetime import date, timedelta
from azure.common.credentials import ServicePrincipalCredentials
# For Azure portal login
# import automationassets
# For vscode login
from azure.identity import AzureCliCredential
from isodate.isostrf import DATE_BAS_ORD_COMPLETE

# For vscode login
credential = AzureCliCredential()

# For Azure portal login
# def get_automation_runas_credential(runas_connection):
#     from OpenSSL import crypto
#     import binascii
#     from msrestazure import azure_active_directory
#     import adal

#     # Get the Azure Automation RunAs service principal certificate
#     cert = automationassets.get_automation_certificate("AzureRunAsCertificate")
#     pks12_cert = crypto.load_pkcs12(cert)
#     pem_pkey = crypto.dump_privatekey(
#         crypto.FILETYPE_PEM, pks12_cert.get_privatekey())

#     # Get run as connection information for the Azure Automation service principal
#     application_id = runas_connection["ApplicationId"]
#     thumbprint = runas_connection["CertificateThumbprint"]
#     tenant_id = runas_connection["TenantId"]

#     # Authenticate with service principal certificate
#     resource = "https://management.core.windows.net/"
#     authority_url = ("https://login.microsoftonline.com/"+tenant_id)
#     context = adal.AuthenticationContext(authority_url)
#     return azure_active_directory.AdalAuthentication(
#         lambda: context.acquire_token_with_client_certificate(
#             resource,
#             application_id,
#             pem_pkey,
#             thumbprint)
#     )
#
# # Authenticate to Azure using the Azure Automation RunAs service principal
# runas_connection = automationassets.get_automation_connection(
#     "AzureRunAsConnection")
# credential = get_automation_runas_credential(runas_connection)

# Initiate sub client
subscription_client = SubscriptionClient(credential)
subscription_ids = subscription_client.subscriptions.list()


today = date.today()
last_two_weeks = today - datetime.timedelta(days=4)

# Monitor function for vms 
def fetch_metrics (monitor_client, resource_id, metricnames, interval = 'PT24H'):
    metrics_data = monitor_client.metrics.list(
        resource_id,
        timespan="{}/{}".format(last_two_weeks, today),
        interval=interval,
        metricnames='Percentage CPU',
        aggregation='Average,Maximum',
    )
    # Get vm metrics by cpu average usage utilization.
    sum = 0 
    count = 0 
    sum_2 = 0
    count_2 =0
    for item in metrics_data.value:
        for timeserie in item.timeseries:
            for data in timeserie.data:
                sum = sum + data.average 
                sum_2 = sum_2 + data.maximum
                count = count + 1 
                count_2 = count_2 + 1
    return [resource_id, sum/count, sum_2/count_2]

# Iterate all vms and get their cpu utilization.
with open('/home/yahav/cpu_memory_utilization_average.csv', 'a') as file:
    field_names = ['Resource id', 'Average','Maximum']
    writer = csv.DictWriter(file, fieldnames=field_names)
    writer.writeheader()
    for sub in list(subscription_ids):
        compute_client = ComputeManagementClient(credential, subscription_id=sub.subscription_id)
        monitor_client = MonitorManagementClient(credential, subscription_id=sub.subscription_id)
        vm_list = compute_client.virtual_machines.list_all()
        for vm in list(vm_list):
            fetch_data = fetch_metrics(monitor_client, vm.id, metricnames='Percentage CPU')
            writer.writerow({'Resource id': fetch_data[0],'Average': fetch_data[1], 'Maximum': fetch_data[2]})
