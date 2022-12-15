#!/bin/bash

aws route53 list-resource-record-sets --hosted-zone-id "/vidaahub.com/Z0417720YU4MKKBPN5X2" | jq -r '.ResourceRecordSets[] | [.Name, .Type, (.ResourceRecords[]? | .Value), .AliasTarget.DNSName?] | @csv'