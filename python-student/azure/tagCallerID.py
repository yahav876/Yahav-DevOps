# Import module dependencies

from azure.identity import AzureCliCredential
from azure.mgmt import resource
from azure.mgmt.resource import ResourceManagementClient
from azure.mgmt.network import NetworkManagementClient
from azure.mgmt.compute import ComputeManagementClient
from azure.mgmt.resource import SubscriptionClient
import os

print(f"Provisioning the first Vm in azure...")

# Get credintial az cli
credential = AzureCliCredential()

# Initialzie subscription client object
sub_client = SubscriptionClient(credential)

# Get all subscriptions ids that the account can access
subscriptions_list = sub_client.subscriptions.list()


list_rg = ResourceManagementClient(list)

print(list_rg)