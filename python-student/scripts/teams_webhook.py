import requests


json_data = {
    "@type": "MessageCard",
    "@context": "http://schema.org/extensions",
    "themeColor": "0076D7",
    "summary": "summry",
    "sections": [{
        "activityTitle": "[告警状态]: PROBLEM\n[告警时间]: 2022-12-26 00:51:00\n[监控项]:\nlive_channel/index_name=live_channel,monitor_type=total_online_num,venderId=60010\n[问题信息]:\n\n[告警详情]:\nnjbp-mam-assetgrabber-svc || falcon || 20.0 < 1000.0\n'}",
        "activityImage": "https://teamsnodesample.azurewebsites.net/static/img/image5.png",
        "facts": [{
            "name": "Assigned to",
            "value": "Unassigned"
        }, {
            "name": "Due date",
            "value": "Mon May 01 2017 17:07:18 GMT-0700 (Pacific Daylight Time)"
        }, ],
        "markdown": "true"
    }],
    "potentialAction": [{
        "@type": "ActionCard",
        "name": "Add a comment",
        "inputs": [{
            "@type": "TextInput",
            "id": "comment",
            "isMultiline": "false",
            "title": "Add a comment here for this task"
        }],
        "actions": [{
            "@type": "HttpPOST",
            "name": "Add comment",
            "target": "https://learn.microsoft.com/outlook/actionable-messages"
        }]
    }, {
        "@type": "ActionCard",
        "name": "Change status",
        "inputs": [{
            "@type": "MultichoiceInput",
            "id": "list",
            "title": "Select a status",
            "isMultiSelect": "false",
            "choices": [{
                "display": "In Progress",
                "value": "1"
            }, {
                "display": "Active",
                "value": "2"
            }, {
                "display": "Closed",
                "value": "3"
            }]
        }],
    }]
}

webhook = "https://vidaausa.webhook.d99/694ccd5f-1676-413e-9f93-0cf947a1fe38"
send = requests.post(webhook, json=json_data)



