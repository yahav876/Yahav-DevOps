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
import datetime
from typing import List
from azure.mgmt import resource
from azure.mgmt.monitor import MonitorManagementClient
from azure.mgmt.resource import SubscriptionClient
from azure.mgmt.resource import ResourceManagementClient
from datetime import datetime, timedelta
import psutil
from azure.common.credentials import ServicePrincipalCredentials
import automationassets


def get_automation_runas_credential(runas_connection):
    from OpenSSL import crypto
    import binascii
    from msrestazure import azure_active_directory
    import adal

    # Get the Azure Automation RunAs service principal certificate
    cert = automationassets.get_automation_certificate("AzureRunAsCertificate")
    pks12_cert = crypto.load_pkcs12(cert)
    pem_pkey = crypto.dump_privatekey(
        crypto.FILETYPE_PEM, pks12_cert.get_privatekey())

    # Get run as connection information for the Azure Automation service principal
    application_id = runas_connection["ApplicationId"]
    thumbprint = runas_connection["CertificateThumbprint"]
    tenant_id = runas_connection["TenantId"]

    # Authenticate with service principal certificate
    resource = "https://management.core.windows.net/"
    authority_url = ("https://login.microsoftonline.com/"+tenant_id)
    context = adal.AuthenticationContext(authority_url)
    return azure_active_directory.AdalAuthentication(
        lambda: context.acquire_token_with_client_certificate(
            resource,
            application_id,
            pem_pkey,
            thumbprint)
    )


# Authenticate to Azure using the Azure Automation RunAs service principal
runas_connection = automationassets.get_automation_connection(
    "AzureRunAsConnection")
credential = get_automation_runas_credential(runas_connection)




subscription_id = "5ff6992d-a095-4f58-a41d-e4d6fc974a53"
resource_group = "a2_group"
vm_name = "cpu-memory-usage"

monitor_client = MonitorManagementClient(
        credential, subscription_id=subscription_id)


resource_id = (
    "subscriptions/{}/"
    "resourceGroups/{}/"
    "providers/Microsoft.Compute/virtualMachines/{}"
).format(subscription_id, resource_group, vm_name)


for metric in monitor_client.metric_definitions.list(resource_id):
    print("{}: id={}, unit={}".format(
        metric.name.localized_value,
        metric.name.value,
        metric.unit
    ))

today = datetime.now().date()
yesterday = today - datetime.timedelta(days=1)

metrics_data = monitor_client.metrics.list(
    resource_id,
    timespan="{}/{}".format(yesterday, today),
    interval='PT1H',
    metric='Precentage CPU',
    aggregation='Total'
)
    
















# try:
#     # Initialzie subscription client object
#     sub_client = SubscriptionClient(credential)

#     # Get all subscriptions ids that the account can access
#     subscription_list_all = sub_client.subscriptions.list()

#     # Get all RG in the subscription
#     resource_group_client = ResourceManagementClient(credential, subscription_id=subscription_list_all)

#     # Retrive the list of RG
#     rg_list = resource_group_client.resource_groups.list()

#     print(rg_list)
# Monitor client

# except Exception as exception:
#     print(repr(exception))

# finally:
#     print(f'\nScript execution finished at {datetime.now().strftime("%d/%m/%Y %H:%M:%S")}')
