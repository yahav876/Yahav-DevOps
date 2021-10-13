#!/usr/bin/env python3

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
from azure.mgmt.policyinsights import PolicyInsightsClient
from azure.mgmt.resource import PolicyClient, ResourceManagementClient



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
with open('/home/yahav/Downloads/rgs-click.csv', mode='r',) as file:
    csv_reader = csv.DictReader(file)
    all_rows = [row for row in csv_reader]

    for sub in subscription_ids:
        # policy = PolicyInsightsClient(credential=credential, subscription_id=sub.subscription_id)
        with open('/home/yahav/Downloads/deny_policy_data_30-09-2021_09 57 23.csv', mode='r',) as file_click:
            policy_reader = csv.DictReader(file_click)
            row_data = [id for id in policy_reader]
            print(row_data)
            policy_client = PolicyClient(credential=credential, subscription_id=sub.subscription_id)
           
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
                get_deny = policy_client.policy_assignments.list_for_resource_group(resource_group_name=rg.Resource-group-name)
                deny_ids = []
                for p in get_deny:
                    deny_ids.append(p.policy_definition_id.split('/')[4])
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
                if deny_ids in row_data:
                    print("Cannot tag the resource group")
                else:
                    resource_group_client.tags.update_at_scope(rg["Resource-id"] , body)


