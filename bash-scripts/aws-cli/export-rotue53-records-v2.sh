#!/bin/bash

aws route53 list-resource-record-sets --hosted-zone-id "/vi.com/ds" | jq -r '.ResourceRecordSets[] | [.Name, .Type, (.ResourceRecords[]? | .Value), .AliasTarget.DNSName?] | @csv'