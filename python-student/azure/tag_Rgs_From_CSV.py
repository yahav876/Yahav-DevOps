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
import requests
from azure.mgmt.monitor import MonitorManagementClient
from azure.mgmt.resource import SubscriptionClient, subscriptions
from azure.mgmt.resource import ResourceManagementClient
from azure.mgmt.compute import ComputeManagementClient
from azure.mgmt.billing import BillingManagementClient
import datetime
# import openpyxl
# from pathlib import Path
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

tags =  ["Environment", "Owner", "FinOps-email", "Cost-Center"]

rg_names = []


# Open CSV file with read mode.
with open('/home/yahav/Downloads/rgs-green.csv', mode='r',) as file:
    csv_reader = csv.DictReader(file)
    all_rows = [row for row in csv_reader]

    for sub in subscription_ids:
        # Validate sub names within the CSV.
        sub_exist = []
        for row in all_rows:
            if sub.display_name == row['SUBSCRIPTION']:
                sub_exist.append(row)

        #Initiate rg client
        resource_group_client = ResourceManagementClient(credential, subscription_id=sub.subscription_id)
        rg_list = resource_group_client.resource_groups.list()
        rg_names = [rg.name for rg in rg_list]        

        # Validate rg names within the CSV.
        rg_exist = [rg for rg in sub_exist if rg["Resource-group-name"] in rg_names]
        
        # Create a dict with the tags names and their values like in the CSV.
        for rg in rg_exist:
            tags_dict = {}
            for tag in tags:
                tags_dict[tag] = rg[tag]
                

            # Tag the resource groups.
            body = {
                "operation" :  "Merge",
                "properties" : {
                    "tags" : 
                        tags_dict,
                }
            }
            resource_group_client.tags.update_at_scope(rg["Resource-id"] , body)


