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
from azure.mgmt import core, resource
from azure.mgmt import compute
import requests
from azure.mgmt.monitor import MonitorManagementClient
from azure.mgmt.resource import SubscriptionClient, subscriptions
from azure.mgmt.resource import ResourceManagementClient
from azure.mgmt.compute import ComputeManagementClient
from azure.mgmt.billing import BillingManagementClient
import datetime
import csv
from datetime import date, timedelta
from azure.common.credentials import ServicePrincipalCredentials
# For Azure portal login
# import automationassets
# For vscode login
from azure.identity import AzureCliCredential
from isodate.isostrf import DATE_BAS_ORD_COMPLETE
import adal


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

# filter = "tagName eq 'right_size' and tagValue eq 'false'"

def tag_is_present(tags_dict):
    return tags_dict and tags_dict.get('right_size') == 'false'

for sub in list(subscription_ids):
    compute_client = ComputeManagementClient(credential, subscription_id=sub.subscription_id)
    resource_list = ResourceManagementClient(credential, subscription_id=sub.subscription_id)
    tagged_vms = [vm for vm in compute_client.virtual_machines.list_all() if tag_is_present(vm.tags)]
    original_size = {}
    for vm in tagged_vms:
        original_size[vm.name] = vm.hardware_profile.vm_size
        list_vm_sizes = compute_client.virtual_machine_sizes.list(location=vm.location)
        for vm_size in list_vm_sizes:
            if (original_size[vm.name]) in vm_size.name:
                cores = vm_size.number_of_cores
                memory = vm_size.memory_in_mb
                size = vm_size.name
    for vm in tagged_vms:
        right_size = ""
        available_sizes = compute_client.virtual_machines.list_available_sizes(resource_group_name=vm.id.split('/')[4],vm_name=vm.name)
        for a in list(available_sizes):
            if a.number_of_cores == cores/2 and a.memory_in_mb < memory/2:
                right_size = a.name
                break
        if not right_size:
            print(f"No Available Resize For The VM: '{vm.name}'")
        else:
            vm_resize = compute_client.virtual_machines.begin_update(resource_group_name=vm.id.split('/')[4],vm_name=vm.name,parameters={'location': vm.location, 'hardware_profile':{'vm_size': right_size}})
            vm_log = compute_client.virtual_machines.get(resource_group_name=vm.id.split('/')[4],vm_name=vm.name)
            if vm_log.hardware_profile.vm_size == right_size:
                print(f"Vm Name:'{vm_log.name}' Changed from {original_size[vm_log.name]} To {right_size}")
            else:
                print(f"Falied to change {vm_log.name} size.")

