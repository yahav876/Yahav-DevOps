resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = var.general_config.dashboard_name
  depends_on = [
      data.aws_instance.allinone,
      data.aws_instance.website
  ]

  dashboard_body = <<EOF
{
    "widgets": [
        {
            "height": 6,
            "width": 12,
            "y": 1,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/EC2", "CPUUtilization", "InstanceId", "${data.aws_instance.allinone.id}", { "label": "${var.general_config.allinone_name}" } ],
                    [ "...", "${data.aws_instance.website.id}", { "label": "${var.general_config.website_name}" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.general_config.region}",
                "stat": "Maximum",
                "period": 300,
                "title": "EC2 CPU Utilization"
            }
        },
        {
            "height": 6,
            "width": 12,
            "y": 14,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "${data.terraform_remote_state.rds_qa.outputs.db-stage-id}" ],
                    [ "...", "${data.terraform_remote_state.rds_qa.outputs.db-strapi-id}" ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.general_config.region}",
                "stat": "Maximum",
                "period": 300,
                "title": "RDS CPU utilization"
            }
        },
        {
            "height": 3,
            "width": 15,
            "y": 27,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SQS", "ApproximateAgeOfOldestMessage", "QueueName", "prod_zoom_events" ],
                    [ "...", "prod_video_participants_management" ],
                    [ "...", "prod_zoom_meeting_status" ]
                ],
                "view": "singleValue",
                "region": "${var.general_config.region}",
                "stat": "Average",
                "period": 3600,
                "title": "SQS oldest messages"
            }
        },
        {
            "height": 6,
            "width": 12,
            "y": 1,
            "x": 12,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "CWAgent", "mem_used_percent", "InstanceId", "${data.aws_instance.website.id}", "ImageId", "${data.aws_instance.website.ami}", "InstanceType", "${data.aws_instance.website.instance_type}", { "label": "${var.general_config.website_name}"} ],
                    [ "...", "${data.aws_instance.allinone.id}", ".","${data.aws_instance.allinone.ami}", ".", "${data.aws_instance.allinone.instance_type}", { "label": "${var.general_config.allinone_name}" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.general_config.region}",
                "title": "EC2 Memory Utilization",
                "period": 300,
                "stat": "Maximum"
            }
        },
        {
            "height": 1,
            "width": 24,
            "y": 0,
            "x": 0,
            "type": "text",
            "properties": {
                "markdown": "## EC2\n"
            }
        },
        {
            "height": 1,
            "width": 24,
            "y": 13,
            "x": 0,
            "type": "text",
            "properties": {
                "markdown": "## RDS"
            }
        },
        {
            "height": 6,
            "width": 12,
            "y": 7,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "CWAgent", "disk_used_percent", "path", "/", "InstanceId", "${data.aws_instance.website.id}", "ImageId", "${data.aws_instance.website.ami}", "InstanceType", "${data.aws_instance.website.instance_type}", "device", "nvme0n1p1", "fstype", "ext4", { "label": "${var.general_config.website_name}" } ],
                    [ "...", "${data.aws_instance.allinone.id}", ".", "${data.aws_instance.allinone.ami}", ".", "${data.aws_instance.allinone.instance_type}", ".", ".", ".", ".", { "label": "${var.general_config.allinone_name}" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.general_config.region}",
                "title": "EC2 Disk Space",
                "period": 300,
                "stat": "Average"
            }
        },
        {
            "height": 1,
            "width": 24,
            "y": 20,
            "x": 0,
            "type": "text",
            "properties": {
                "markdown": "## Other Services"
            }
        },
        {
            "height": 6,
            "width": 12,
            "y": 14,
            "x": 12,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/RDS", "ReadLatency", "DBInstanceIdentifier", "${data.terraform_remote_state.rds_qa.outputs.db-stage-id}" ],
                    [ "...", "${data.terraform_remote_state.rds_qa.outputs.db-strapi-id}" ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.general_config.region}",
                "stat": "Maximum",
                "period": 300
            }
        },
        {
            "height": 3,
            "width": 9,
            "y": 27,
            "x": 15,
            "type": "metric",
            "properties": {
                "view": "singleValue",
                "metrics": [
                    [ "AWS/SNS", "NumberOfNotificationsFailed", "TopicName", "prod_video_meeting" ],
                    [ "...", "prod_subscription" ]
                ],
                "region": "${var.general_config.region}",
                "title": "failing SNS messages"
            }
        },
        {
            "height": 6,
            "width": 24,
            "y": 21,
            "x": 0,
            "type": "metric",
            "properties": {
                "view": "timeSeries",
                "metrics": [
                    [ "AWS/CloudFront", "4xxErrorRate", "Region", "Global", "DistributionId", "E147TFJB1AC3RR", { "region": "us-east-2" } ],
                    [ ".", "5xxErrorRate", ".", ".", ".", ".", { "region": "us-east-2" } ],
                    [ ".", "Requests", ".", ".", ".", ".", { "region": "us-east-2" } ]
                ],
                "region": "${var.general_config.region}",
                "stacked": true,
                "title": "HTTP requests and errors"
            }
        }
    ]
}
EOF
}