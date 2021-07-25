# Import module dependencies
import csv
from datetime import datetime, timedelta
import azure.identity._exceptions
from azure.identity import AzureCliCredential
from azure.mgmt.monitor import MonitorManagementClient
from azure.mgmt.resource import SubscriptionClient

# Use local azure credentials of logged in session using 'az login' or Connect-AzAccount
credential = AzureCliCredential()
# Initialzie subscription client object
sub_client = SubscriptionClient(credential)
# Get all subscriptions ids that the account can access
subscriptions_list = sub_client.subscriptions.list()

# Getting an excluded subscriptions ids and names from CSV file
excluded_subscriptions = {'subscription_id':[], 'subscription_name':[]}
try:
    with open('excluded_subscriptions.csv') as csv_file:
        csv_reader = csv.DictReader(csv_file)
        for row in csv_reader:
            excluded_subscriptions['subscription_id'].append(row['subscription_id'])
            excluded_subscriptions['subscription_name'].append(row['subscription_name'])
except Exception as exception:
    print(f'Problem with excluded_subscriptions.csv file\nNo exclusions will be checked!\nError value: {repr(exception)}\n')

try:
    # Looping over the excluded subscriptions ids with ids from the azure subscriptions itself and saving only those not excluded
    subscription_ids = []
    for sub in subscriptions_list:
        if sub.subscription_id not in excluded_subscriptions['subscription_id']:
            subscription_ids.append(sub.subscription_id)

    # Get object of a date by the number of days specified
    minutes = 0
    hours = 6
    days = 0
    date = datetime.now() - timedelta(minutes=minutes, hours=hours, days=days)

    # Create CSV file for exporting the unused subscriptions ids and names
    unused_subscriptions_csv_file = open(f'unused_subscriptions_{datetime.now().strftime("%d-%m-%Y_%H:%M:%S")}.csv', mode='a')
    fieldnames = ['subscription_id', 'subscription_name']
    writer = csv.DictWriter(unused_subscriptions_csv_file, fieldnames=fieldnames)
    writer.writeheader()

    subs_events = {}
    # Loop over all ids
    for sub_id in subscription_ids:
        # Initialize azure monitor management client object with each subscription id
        monitor = MonitorManagementClient(credential=credential,subscription_id=sub_id)
        # Get the following data from all activity logs in subscription newer than the specified date
        activity_logs = monitor.activity_logs.list(filter=f"eventTimestamp ge {date}",select='subscriptionId,claims,caller,eventTimestamp,submissionTimestamp')
        
        # Getting the activity logs enamurated value and checking if the value is not empty
        try:
            activity_logs_events = enumerate(activity_logs)
            max(activity_logs_events)
        
        # If the value of the enumerate activity logs is empty catch the exception.
        # Export and print those subscriptions ids and names
        except ValueError:
            writer.writerow({'subscription_id': sub_id, 'subscription_name': sub_client.subscriptions.get(sub_id).display_name})
            print(f"""Subscription ID: {sub_id}
                \rSubscription Name: {sub_client.subscriptions.get(sub_id).display_name}
                """)
        
        # If the activity logs enamurated values not empty, start looping on them
        else:
            for iter,event in activity_logs_events:
                dict_items = {}
                event_dict = event.as_dict()
                found = False

                # Loop and populate new dictionary object with the relevant data only from the activity_logs object
                if 'caller' in event_dict.keys():
                    # If the 'caller' username is the format of an Azure AD user principal name
                    if '@' in event_dict['caller'] and len(event_dict['caller'].split('@')) == 2 and '.' in event_dict['caller'].split('@')[1]:
                        # If the event dictionary have the user ip address and a user full name
                        if 'ipaddr' in event_dict['claims'].keys() and 'name' in event_dict['claims'].keys(): 
                            # If the previous conditions were found and so the event was created by a real person, end the loop
                            found = True
                            break
                
                # Export and print the subscriptions ids and names
                if not found:
                    writer.writerow({'subscription_id': event_dict['subscription_id'], 'subscription_name': sub_client.subscriptions.get(event_dict['subscription_id']).display_name})
                    print(f"""Subscription ID: {event_dict['subscription_id']}
                        \rSubscription Name: {sub_client.subscriptions.get(event_dict['subscription_id']).display_name}
                        """)

# Catching the exception of when no local azure login token is available on local computer
except azure.identity._exceptions.CredentialUnavailableError as exception:
    print(repr(exception))

finally:
    # Close unused subscriptions CSV file 
    unused_subscriptions_csv_file.close()
    print(f'Script finished at {datetime.now().strftime("%d-%m-%Y_%H:%M:%S")}')