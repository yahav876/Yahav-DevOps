#!/usr/bin/env python3

# Import module dependencies
from datetime import datetime, timedelta
from azure.mgmt.monitor import MonitorManagementClient
from azure.mgmt.resource import SubscriptionClient
from azure.common.credentials import ServicePrincipalCredentials
from azure.mgmt.consumption import ConsumptionManagementClient
import azure.mgmt.policyinsights
import azure.mgmt.resource  
import azure.cli.core
import humanfriendly
import knack
import pkginfo
import argcomplete
from azure.mgmt.managementgroups import ManagementGroupsAPI
from azure.common.credentials import get_azure_cli_credentials
from azure.common.client_factory import get_client_from_cli_profile
from azure.mgmt.resource.policy import PolicyClient
from azure.mgmt.resource.policy.models import PolicyAssignment


import automationassets

def get_automation_runas_credential(runas_connection):
    from OpenSSL import crypto
    import binascii
    from msrestazure import azure_active_directory
    import adal

    # Get the Azure Automation RunAs service principal certificate
    cert = automationassets.get_automation_certificate("AzureRunAsCertificate")
    pks12_cert = crypto.load_pkcs12(cert)
    pem_pkey = crypto.dump_privatekey(crypto.FILETYPE_PEM,pks12_cert.get_privatekey())

    # Get run as connection information for the Azure Automation service principal
    application_id = runas_connection["ApplicationId"]
    thumbprint = runas_connection["CertificateThumbprint"]
    tenant_id = runas_connection["TenantId"]

    # Authenticate with service principal certificate
    resource ="https://management.core.windows.net/"
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
runas_connection = automationassets.get_automation_connection("AzureRunAsConnection")
credential = get_automation_runas_credential(runas_connection)

# List mgmnt groups def

def list_mgmt(list):
    mgmt_group_api = ManagementGroupsAPI(credential)
    entities = mgmt_group_api.entities.list()
    

print(list_mgmt)


# Get your credentials from Azure CLI (development only!) and get your subscription list
policyClient = PolicyClient(credentials=credential,subscription_id='5ff6992d-a095-4f58-a41d-e4d6fc974a53')



#print (mgmnt_list.list(cache_control='no-cache', skiptoken=None, **kwargs))



# Create details for the assignment
policyAssignmentDetails = PolicyAssignment(display_name="Inherit Tag from resource group", policy_definition_id="/providers/Microsoft.Authorization/policyDefinitions/ea3f2387-9b95-492a-a190-fcdc54f7b070", scope="{/providers/Microsoft.Management/managementGroups/m1}", description="Inherit the tag from each resource group to any resource that deployed.")

# Create new policy assignment
policyAssignment = policyClient.policy_assignments.create("{/providers/Microsoft.Management/managementGroups/m1}", "audit-vm-manageddisks", policyAssignmentDetails)

# Show results
print(policyAssignment)