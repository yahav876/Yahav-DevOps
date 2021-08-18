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



# ,"Environment", "Owner", "FinOps-email", "Cost-Center"]
# , encoding='latin-1'
# , fieldnames=field_names
# file = Path('/home/yahav/Downloads/rgs-green.xlsx')
#     field_names = ["Resource-group-name", "SUBSCRIPTION"]

tags =  ["Environment", "Owner", "FinOps-email", "Cost-Center"]
rg_sub_names = ["Resource-group-name", "SUBSCRIPTION"]

match_rg_names = []
match_sub_names = []
match_tag_names = []

sub_names = []
rg_names = []

with open('/home/yahav/Downloads/rgs-green.csv', mode='r') as file:
    csv_reader = csv.DictReader(file)
    all_rows = [row for row in csv_reader]
    #match_rg_names = [row[rg_sub_names[0]] for row in all_rows]
    #match_sub_names = [row[rg_sub_names[1]] for row in all_rows]
    # print(all_rows)
    #match_tag_names = [row[tags[0]] for row in all_rows]
        # for tag in tags:
        #     tags_dict[tag] = row[tag]
    # tags_dict = dict.fromkeys(tags,tags[all_rows])
    # print(tags_dict)
    # print(match_tag_names)
    for sub in subscription_ids:
        sub_list = []
        for row in all_rows:
            if sub.display_name == row['SUBSCRIPTION']:
                sub_list.append(row)
        
        #Initiate rg client
        resource_group_client = ResourceManagementClient(credential, subscription_id=sub.subscription_id)
        rg_list = resource_group_client.resource_groups.list()
        rg_names = [rg.name for rg in rg_list]
        
        rg_exist = []
        for rg in sub_list:
            if rg["Resource-group-name"] in rg_names:
                rg_exist.append(rg)
                
        for rg in rg_exist:
            tags_dict = {}
            for tag in tags:
                tags_dict[tag] = rg[tag]

            resource_group_client.resource_groups.create_or_update(resource_group_name=rg["Resource-group-name"],parameters=
            {'location': rg['location'], 
                'tags':tags_dict})
            # # print(match_sub_names)
            #     for rg in rg_list:
            #         if rg.name in match_rg_names:
            #         print(rg.name)
                    # resource_group_client.resource_groups.create_or_update
            #     print(rg.id)
            # rg_names = rg.name
            # print(rg_names)
    # if match_rg_names in row[rg_sub[0]]:
    #     print(match_rg_names)
            #     print(rg.name)
            
        # if sub.display_name in row[field_names_rg_sub[1]]:
        #     print(sub.display_name)
    # print(tags)
    # print(row[field_names[0]], row[field_names[1]])
    


