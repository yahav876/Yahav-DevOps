#!/bin/bash

profile="2019"
zonename="vidaahub.com"
hostedzoneid=$(aws route53 list-hosted-zones --output json --profile=$profile | jq -r ".HostedZones[] | select(.Name == \"$zonename.\") | .Id" | cut -d'/' -f3)
aws route53  list-resource-record-sets --hosted-zone-id $hostedzoneid --output json --profile=$profile | jq -jr '.ResourceRecordSets[] | "\(.Name) \t\(.TTL) \t\(.Type) \t\(.ResourceRecords[]?.Value)\n"' 