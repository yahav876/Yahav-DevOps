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
from datetime import date, timedelta
from azure.common.credentials import ServicePrincipalCredentials
# For Azure portal login
# import automationassets
# For vscode login
from azure.identity import AzureCliCredential

# For vscode login
credential = AzureCliCredential() 

## For Azure portal login
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


vm_id_array = []

# Iterate all subs , rgs , vms and get their ids/names into an array.
for sub in list(subscription_ids):
    rg_client = ResourceManagementClient(
        credential, subscription_id=sub.subscription_id)
    rg_list = rg_client.resource_groups.list()
    for rg in list(rg_list):
        compute_client = ComputeManagementClient(
            credential, subscription_id=sub.subscription_id)
        vm_list = compute_client.virtual_machines.list(
            resource_group_name=rg.name)
        for vm in list(vm_list):
            vm_id_array.append(vm.id)

print(f"Virtual Machines Name: {vm_id_array}")

today = date.today()
last_two_weeks = today - datetime.timedelta(days=1)

for sub_id in sub_id_array:
    monitor_client = MonitorManagementClient(credential, subscription_id=sub_id)

for vm_id in vm_id_array:
    metrics_data = monitor_client.metrics.list(
        vm_id,
        timespan="{}/{}".format(last_two_weeks, today),
        interval='PT1H',
        metricnames='Percentage CPU',
        aggregation='Total'
            )
    for item in metrics_data.value:
        print("{} ({})".format(item.name.localized_value, item.unit))
        for timeserie in item.timeseries:
            for data in timeserie.data:
                print("{}: {}".format(data.time_stamp, data.total))

