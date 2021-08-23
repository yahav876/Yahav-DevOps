resource "aws_iam_policy" "SchedulerPolicy" {
  name        = "${var.general_config.ProjectName}-${var.general_config.aws_region}-instance-Scheduler-Policy"
  path        = "/"

  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [{
			"Action": [
				"logs:CreateLogGroup",
				"logs:CreateLogStream",
				"logs:PutLogEvents",
				"logs:PutRetentionPolicy"
			],
			"Effect": "Allow",
			"Resource": [
				"${aws_cloudwatch_log_group.SchedulerLogGroup.arn}:*",
				"*"
			]
		},
		{
			"Action": [
				"rds:DeleteDBSnapshot",
				"rds:DescribeDBSnapshots",
				"rds:StopDBInstance"
			],
			"Effect": "Allow",
			"Resource": [
				"*"
			]
		},
		{
			"Action": [
				"rds:AddTagsToResource",
				"rds:RemoveTagsFromResource",
				"rds:DescribeDBSnapshots",
				"rds:StartDBInstance",
				"rds:StopDBInstance"
			],
			"Effect": "Allow",
			"Resource": [
				"*"
			]
		},
		{
			"Action": [
				"rds:AddTagsToResource",
				"rds:RemoveTagsFromResource",
				"rds:StartDBCluster",
				"rds:StopDBCluster"
			],
			"Effect": "Allow",
			"Resource": [
				"*"
			]
		},
		{
			"Action": [
				"ec2:StartInstances",
				"ec2:StopInstances",
				"ec2:CreateTags",
				"ec2:DeleteTags",
                "kms:CreateGrant"
			],
			"Effect": "Allow",
			"Resource": [
				"*"
			]
		},
		{
			"Action": [
				"dynamodb:DeleteItem",
				"dynamodb:GetItem",
				"dynamodb:PutItem",
				"dynamodb:Query",
				"dynamodb:Scan",
				"dynamodb:BatchWriteItem"
			],
			"Effect": "Allow",
			"Resource": [
				"*"
			]
		},
		{
			"Action": [
				"sns:Publish"
			],
			"Effect": "Allow",
			"Resource": [
				"*"
			]
		},
		{
			"Action": [
				"lambda:InvokeFunction"
			],
			"Effect": "Allow",
			"Resource": [
				"*"
			]
		},
		{
			"Action": [
				"logs:DescribeLogStreams",
				"rds:DescribeDBClusters",
				"rds:DescribeDBInstances",
				"ec2:DescribeInstances",
				"ec2:DescribeRegions",
				"ec2:ModifyInstanceAttribute",
				"cloudwatch:PutMetricData",
				"ssm:GetParameter",
				"ssm:GetParameters",
				"ssm:DescribeMaintenanceWindows",
				"tag:GetResources",
				"sts:AssumeRole"
			],
			"Effect": "Allow",
			"Resource": [
				"*"
			]
		}
	]
}
EOF
}

resource "aws_iam_role" "SchedulerRole" {
  name = "instance-scheduler-role-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    },
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role" "SchedulerDynamoDBScalingRole" {
  name = "dynamoDB-scaling-role-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
  depends_on = [aws_iam_role.SchedulerRole]
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "application-autoscaling.amazonaws.com"
      },
      "Effect": "Allow"
    },
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "${aws_iam_role.SchedulerRole.arn}"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "SchedulerDynamoDBScalingPolicy" {
  for_each =  toset([
    "arn:aws:iam::aws:policy/service-role/AWSLambdaDynamoDBExecutionRole",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  ])
  role       = aws_iam_role.SchedulerDynamoDBScalingRole.name
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "attach_SchedulerDynamoDBScaling2" {

  role       = aws_iam_role.SchedulerRole.name
  policy_arn = aws_iam_policy.SchedulerPolicy.arn
}

resource "aws_appautoscaling_target" "StateTableAutoScalingReadTarget" {
  max_capacity       = local.settings.appASTmax
  min_capacity       = local.settings.appASTmin
  resource_id        = "table/${aws_dynamodb_table.StateTable.id}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
  role_arn           = aws_iam_role.SchedulerDynamoDBScalingRole.arn

}

resource "aws_appautoscaling_policy" "StateTableAutoScalingReadPolicy" {
  name               = "${var.general_config.ProjectName}-StateTableAutoScalingReadPolicy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.StateTableAutoScalingReadTarget.resource_id
  scalable_dimension = aws_appautoscaling_target.StateTableAutoScalingReadTarget.scalable_dimension
  service_namespace  = aws_appautoscaling_target.StateTableAutoScalingReadTarget.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 75
    scale_in_cooldown = 60
    scale_out_cooldown = 60
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
  }
  depends_on = [aws_appautoscaling_target.StateTableAutoScalingReadTarget]
}

resource "aws_appautoscaling_target" "StateTableAutoScalingWriteTarget" {
  max_capacity       = local.settings.appASTmax
  min_capacity       = local.settings.appASTmin
  resource_id        = "table/${aws_dynamodb_table.StateTable.id}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits" # #dynamoDBReadCapacityUtilization
  service_namespace  = "dynamodb"
  role_arn           = aws_iam_role.SchedulerDynamoDBScalingRole.arn

  depends_on = [aws_appautoscaling_target.StateTableAutoScalingReadTarget]
}

resource "aws_appautoscaling_policy" "StateTableAutoScalingWritePolicy" {
  depends_on = [aws_appautoscaling_target.StateTableAutoScalingWriteTarget]
  name               = "${var.general_config.ProjectName}-StateTableAutoScalingWritePolicy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.StateTableAutoScalingWriteTarget.resource_id
  scalable_dimension = aws_appautoscaling_target.StateTableAutoScalingWriteTarget.scalable_dimension
  service_namespace  = aws_appautoscaling_target.StateTableAutoScalingWriteTarget.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 75
    scale_in_cooldown = 60
    scale_out_cooldown = 60
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
  }
}

resource "aws_dynamodb_table" "StateTable" {
  name           = "${var.general_config.ProjectName}-StateTable"
  read_capacity  = local.settings.dynamodbRead
  write_capacity = local.settings.dynamodbWrite
  hash_key       = "service"
  range_key      = "account-region"

  attribute {
    name = "service"
    type = "S"
  }

  attribute {
    name = "account-region"
    type = "S"
  }

  tags = local.tag_dynamo
}

resource "aws_dynamodb_table" "ConfigTable" {
  name           = "${var.general_config.ProjectName}-ConfigTable"
  read_capacity  = local.settings.dynamodbRead
  write_capacity = local.settings.dynamodbWrite
  hash_key       = "type"
  range_key      = "name"

  attribute {
    name = "type"
    type = "S"
  }

  attribute {
    name = "name"
    type = "S"
  }

  tags = local.tag_dynamo
}

resource "aws_dynamodb_table" "MaintenanceTable" {
  name           = "${var.general_config.ProjectName}-MaintenanceWindowTable"
  read_capacity  = local.settings.dynamodbRead
  write_capacity = local.settings.dynamodbWrite
  hash_key       = "name"
  range_key      = "account-region"

  attribute {
    name = "name"
    type = "S"
  }

  attribute {
    name = "account-region"
    type = "S"
  }

  tags = local.tag_dynamo
}

resource "aws_dynamodb_table_item" "Config" {
  table_name = aws_dynamodb_table.ConfigTable.name
  hash_key   = aws_dynamodb_table.ConfigTable.hash_key
  range_key  = aws_dynamodb_table.ConfigTable.range_key

  item = <<ITEM
{
  "create_rds_snapshot": {
    "BOOL": false
  },
  "default_timezone": {
    "S": "UTC"
  },
  "enable_SSM_maintenance_windows": {
    "BOOL": false
  },
  "name": {
    "S": "scheduler"
  },
  "regions": {
    "SS": [
      "${var.general_config.aws_region}"
    ]
  },
  "schedule_clusters": {
    "BOOL": false
  },
  "schedule_lambda_account": {
    "BOOL": true
  },
  "scheduled_services": {
    "SS": [
      "ec2",
      "rds"
    ]
  },
  "started_tags": {
    "S": "instanceSchedulerStart=true"
  },
  "stopped_tags": {
    "S": "instanceSchedulerStop=true"
  },
  "tagname": {
    "S": "Schedule"
  },
  "trace": {
    "BOOL": true
  },
  "type": {
    "S": "config"
  },
  "use_metrics": {
    "BOOL": false
  }
}
ITEM
}

resource "aws_dynamodb_table_item" "Periods_months" {
  for_each = var.Periods
  table_name = aws_dynamodb_table.ConfigTable.name
  hash_key = aws_dynamodb_table.ConfigTable.hash_key
  range_key = aws_dynamodb_table.ConfigTable.range_key

  item = <<ITEM
{
  "description": {
    "S": "${each.value.description}"
  },
  "months": {
    "SS": [
      "${each.value.months}"
    ]
  },
  "name": {
    "S": "${each.value.name}"
  },
  "type": {
    "S": "${each.value.type}"
  },
  "weekdays": {
    "SS": [
      "${each.value.weekdays}"
    ]
  }
}
ITEM
}

resource "aws_dynamodb_table_item" "Periods_BegintimeEndtime" {
  for_each = var.Periods-2
  table_name = aws_dynamodb_table.ConfigTable.name
  hash_key = aws_dynamodb_table.ConfigTable.hash_key
  range_key = aws_dynamodb_table.ConfigTable.range_key

  item = <<ITEM
{
  "description": {
    "S": "${each.value.description}"
  },
  "name": {
    "S": "${each.value.name}"
  },
  "begintime": {
    "S": "${each.value.begintime}"
  },
  "endtime": {
    "S":  "${each.value.endtime}"
  },
  "type": {
    "S": "${each.value.type}"
  },
  "weekdays": {
    "SS": [
      "${each.value.weekdays}"
    ]
  }
}
ITEM
}

resource "aws_dynamodb_table_item" "Periods_" {
  for_each = var.Periods-3
  table_name = aws_dynamodb_table.ConfigTable.name
  hash_key = aws_dynamodb_table.ConfigTable.hash_key
  range_key = aws_dynamodb_table.ConfigTable.range_key

  item = <<ITEM
{
  "description": {
    "S": "${each.value.description}"
  },
  "name": {
    "S": "${each.value.name}"
  },
  "type": {
    "S": "${each.value.type}"
  },
  "weekdays": {
    "SS": [
      "${each.value.weekdays}"
    ]
  }
}
ITEM
}

resource "aws_dynamodb_table_item" "Schedules" {
  for_each = var.Schedules
  table_name = aws_dynamodb_table.ConfigTable.name
  hash_key = aws_dynamodb_table.ConfigTable.hash_key
  range_key = aws_dynamodb_table.ConfigTable.range_key

  item = <<ITEM
{
  "description": {
    "S": "${each.value.description}"
  },
  "name": {
    "S": "${each.value.name}"
  },
  "override_status": {
  "S": "${each.value.override_status}"
  },
  "type": {
    "S": "${each.value.type}"
  },
  "use_metrics": {
  "BOOL": ${each.value.use_metrics}
  }
}
ITEM
}

resource "aws_dynamodb_table_item" "Schedules_without_Override_status" {
  for_each = var.Schedules-2
  table_name = aws_dynamodb_table.ConfigTable.name
  hash_key = aws_dynamodb_table.ConfigTable.hash_key
  range_key = aws_dynamodb_table.ConfigTable.range_key

  item = <<ITEM
{
  "description": {
    "S": "${each.value.description}"
  },
  "name": {
    "S": "${each.value.name}"
  },
  "periods": {
    "SS": [
      "${each.value.periods}"
    ]
  },
  "timezone": {
    "S": "${each.value.timezone}"
  },
  "type": {
    "S": "${each.value.type}"
  }
}
ITEM
}

resource "aws_appautoscaling_target" "ConfigTableAutoScalingReadTarget" {
  max_capacity       = local.settings.appASTmax
  min_capacity       = local.settings.appASTmin
  resource_id        = "table/${aws_dynamodb_table.ConfigTable.id}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
  role_arn           = aws_iam_role.SchedulerDynamoDBScalingRole.arn

  depends_on = [aws_appautoscaling_target.StateTableAutoScalingWriteTarget]
}

resource "aws_appautoscaling_policy" "ConfigurationTableAutoScalingReadPolicy" {
  depends_on         = [aws_appautoscaling_target.ConfigTableAutoScalingReadTarget]
  name               = "${var.general_config.ProjectName}-ConfigTableAutoScalingReadPolicy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ConfigTableAutoScalingReadTarget.resource_id
  scalable_dimension = aws_appautoscaling_target.ConfigTableAutoScalingReadTarget.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ConfigTableAutoScalingReadTarget.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 75
    scale_in_cooldown = 60
    scale_out_cooldown = 60
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
  }
}

resource "aws_appautoscaling_target" "ConfigTableAutoScalingWriteTarget" {
  max_capacity       = local.settings.appASTmax
  min_capacity       = local.settings.appASTmin
  resource_id        = "table/${aws_dynamodb_table.ConfigTable.id}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
  role_arn           = aws_iam_role.SchedulerDynamoDBScalingRole.arn

  depends_on         = [aws_appautoscaling_target.ConfigTableAutoScalingReadTarget]

}

resource "aws_appautoscaling_policy" "ConfigTableAutoScalingWritePolicy" {
  depends_on         = [aws_appautoscaling_target.ConfigTableAutoScalingWriteTarget]
  name               = "${var.general_config.ProjectName}-ConfigTableAutoScalingWritePolicy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ConfigTableAutoScalingWriteTarget.resource_id
  scalable_dimension = aws_appautoscaling_target.ConfigTableAutoScalingWriteTarget.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ConfigTableAutoScalingWriteTarget.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 75
    scale_in_cooldown = 60
    scale_out_cooldown = 60
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
  }
}

resource "aws_cloudwatch_log_group" "SchedulerLogGroup" {
  name              = "${var.general_config.ProjectName}-logs"
  retention_in_days = var.general_config.LogRetentionDays
  tags              = local.tag_logs
}

resource "aws_sns_topic" "InstanceSchedulerSnsTopic" {
  name = var.general_config.ProjectName
}

resource "aws_lambda_function" "Main" {
  depends_on    = [aws_iam_role.SchedulerRole]
  filename      =  data.archive_file.source.output_path
  function_name = "${var.general_config.ProjectName}-InstanceSchedulerMain"
  role          = aws_iam_role.SchedulerRole.arn
  handler       = "main.lambda_handler"
  description   = "EC2 and RDS instance scheduler"
  runtime       = "python3.7"
  timeout       = 600
  tracing_config {
    mode = "Active"
  }
  environment {
    variables = {
      ACCOUNT                        = data.aws_caller_identity.current.account_id
      BOTO_RETRY                     = "5,10,30,0.25"
      STACK_NAME                     = var.instance_scheduler.stackName
      START_EC2_BATCH_SIZE           = 5
      CONFIG_TABLE                   = aws_dynamodb_table.ConfigTable.name
      DDB_TABLE_NAME                 = aws_dynamodb_table.StateTable.name
      ENABLE_SSM_MAINTENANCE_WINDOWS = var.instance_scheduler.EnableSSMMaintenanceWindows
      ENV_BOTO_RETRY_LOGGING         = var.instance_scheduler.EnvBotoRetryLogging
      ISSUES_TOPIC_ARN               = aws_sns_topic.InstanceSchedulerSnsTopic.arn
      LOG_GROUP                      = aws_cloudwatch_log_group.SchedulerLogGroup.name
      METRICS_URL                    = local.settings.Metrics.Url
      SCHEDULER_FREQUENCY            = var.instance_scheduler.SchedulerFrequency
      SEND_METRICS                   = var.instance_scheduler.SendAnonymousData
      SOLUTION_ID                    = local.settings.Metrics.SolutionId
      STATE_TABLE                    = aws_dynamodb_table.StateTable.name
      TAG_NAME                       = var.general_config.TagName
      MAINTENANCE_WINDOW_TABLE       = aws_dynamodb_table.MaintenanceTable.name
      TRACE                          = var.instance_scheduler.Trace
    }
  }

  memory_size =  var.instance_scheduler.MemorySize
  tags    = merge(
              tomap({
                "Name" = format("%s-InstanceSchedulerMain", var.general_config.ProjectName)
              }),
              local.tag_lambda,
              {
                description ="EC2 and RDS instance scheduler"
              }
            )

}

resource "aws_lambda_permission" "SchedulerInvokePermission" {
  depends_on    = [aws_lambda_function.Main]
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.Main.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.SchedulerRule.arn
}

resource "aws_cloudwatch_event_rule" "SchedulerRule" {
  name                = "${var.general_config.ProjectName}-${var.instance_scheduler.CloudWatchRuleName}-CloudWatchRule"
  description         = "Instance Scheduler - Rule to trigger instance for scheduler function"
  schedule_expression = var.instance_scheduler.SchedulerFrequency
  is_enabled          = var.instance_scheduler.SchedulingActive
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.SchedulerRule.name
  target_id = "Instance-Scheduler-Main"
  arn       = aws_lambda_function.Main.arn
}

data "aws_lambda_invocation" "SchedulerConfigHelper" {
  depends_on    = [aws_lambda_function.Main, aws_dynamodb_table.ConfigTable, aws_cloudwatch_log_group.SchedulerLogGroup,]
  function_name = aws_lambda_function.Main.function_name

  input = <<JSON
{
    "id": "cdc73f9d-aea9-11e3-9d5a-835b769c0d9c",
    "detail-type": "Scheduled Event",
    "source": "aws.events",
    "account": "123456789012",
    "time": "1970-01-01T00:00:00Z",
    "region": "eu-west-3",
    "resources": [
        "arn:aws:iam::457486133872:role/instance-scheduler-role-457486133872-eu-west-3"
    ],
    "detail": {
        "timeout": "600",
        "config_table": "${aws_dynamodb_table.ConfigTable.id}",
        "tagname": "${var.general_config.TagName}",
        "maintenance_window_table": "${aws_dynamodb_table.MaintenanceTable.id}",
        "default_timezone": "eu-west-1",
        "schedule_clusters": "${var.instance_scheduler.ScheduleRdsClusters}",
        "use_metrics": "${var.instance_scheduler.UseCloudWatchMetrics}",
        "scheduled_services": "${var.instance_scheduler.ScheduledServices}",
        "regions": "[\"${join("\", \"", [var.general_config.aws_region])}\"]",
        "cross_account_roles": "",
        "schedule_lambda_account": "${var.instance_scheduler.ScheduleLambdaAccount}",
        "trace": "${var.instance_scheduler.Trace}",
        "log_retention_days": "${var.instance_scheduler.LogRetentionDays}",
        "started_tags": "[\"${join("\", \"", [var.instance_scheduler.StartedTags])}\"]",
        "stopped_tags": "[\"${join("\", \"", [var.instance_scheduler.StoppedTags])}\"]",
        "stack_version": "2.2.2.0"
    }
}
JSON
}

