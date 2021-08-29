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
from azure.mgmt.resource import SubscriptionClient, subscriptions
from azure.mgmt.billing import BillingManagementClient
from azure.mgmt.costmanagement import CostManagementClient
import datetime
from datetime import date, timedelta
from azure.common.credentials import ServicePrincipalCredentials
# For Azure portal login
# import automationassets
# For vscode login
from azure.identity import AzureCliCredential
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

cost_client = CostManagementClient(credential=credential)

# QueryTimePeriod(*, from_property: datetime.datetime, to: datetime.datetime, **kwargs)

for sub in subscription_ids:
    cost = cost_client.forecast.usage(scope="/subscriptions/5ff6992d-a095-4f58-a41d-e4d6fc974a53/",parameters=
    {"type": "ActualCost",
    "timeframe": "TheLastMonth",
        "dataSet": {
        "granularity": "Daily",
        "aggregation": {
            "totalCost": {
                "name": "Cost",
                "function": "Sum"
            },
            "totalCostUSD": {
                "name": "CostUSD",
                "function": "Sum"
            }
        },
        "sorting": [
            {
                "direction": "ascending",
                "name": "UsageDate"
            }
        ],
        "grouping": [
            {
                "type": "Dimension",
                "name": "SubscriptionId"
            },
            {
                "type": "Dimension",
                "name": "SubscriptionName"
            },
            {
                "type": "Dimension",
                "name": "ChargeType"
            },
            {
                "type": "Dimension",
                "name": "PublisherType"
            }
        ],
        "filter": {
            "And": [
                {
                    "Dimensions": {
                        "Name": "PartnerEarnedCreditApplied",
                        "Operator": "In",
                        "Values": [
                            "true"
                        ]
                    }
                },
                {
                    "Dimensions": {
                        "Name": "CustomerTenantId",
                        "Operator": "In",
                        "Values": [
                            "570d7b25-e9d6-45a5-a12f-e8ab904bdb8a"
                        ]
                    }
                }
            ]
        }
    },
"include_actual_cost": "True",
"include_fresh_partial_cost": "True"
},)

for c in cost.columns:
    print(c)