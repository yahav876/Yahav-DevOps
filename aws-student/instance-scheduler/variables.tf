variable "general_config" {
  description = "general configs for tf module."
  type        = map
  default     = {
    Environment = ""
    Expiration = ""
    account_id = ""
    aws_region = ""
    environment = ""
    application_name = ""
    monitoring = ""
    type = ""
    key_name = ""
    vpc1_cidr = ""
    vpc2_cidr = ""
    add_vpc1_cidr_block = ""
    add_vpc1_third_cidr_block = ""
    VPC1IGW = ""
    VPC2IGW = ""
    CreateVPCEndpoints = ""
    ProjectName = "XXXXX"
    LogRetentionDays = ""
    VPCName = ""
    ProjectName = ""
    DeleteDefaultVpc = ""
    DefaultTimezone = ""
  }

  validation {
    condition = (
      can(var.general_config["LogRetentionDays"]) && contains(["1", "3", "5", "7", "14", "30", "60", "90", "120", "150", "180", "365", "400", "545", "731", "1827", "3653"], var.general_config["LogRetentionDays"])
    )
    error_message = "An LogRetentionDays variable is required and it must be set to either \"1\" or \"3\"..."
  }
}

variable "instance_scheduler" {
  description = "the instance scheduler variables"
  type = map
  default = {
    TagName = "Schedule"          # Name of tag to use for associating instance schedule schemas with service instances.
    SendAnonymousData = "Yes"
    Trace = "No"
    MemorySize = "128"            # Size of the Lambda function running the scheduler, increase size when processing large numbers of instances
    SchedulerFrequency = ""    # Can be 1,2,5,10,15,30,60 in min.
    SchedulingActive = "true"
    DefaultTimezone = "UTC"       # Choose the default Time Zone. Default is 'UTC'
    UseCloudWatchMetrics = "Yes"   # Collect instance scheduling data using CloudWatch metrics.
    ScheduledServices = "Both"     # ScheduledServices Can be EC2 or RDS or Both
    ScheduleLambdaAccount = "Yes" # Schedule instances in this account.
    CreateRdsSnapshot = "No"
    EnableSSMMaintenanceWindows = "False"
    LogRetentionDays = ""
    ScheduleRdsClusters = "Yes"
    Regions = ""
    EnvBotoRetryLogging = ""
    CloudWatchRuleName = ""
    stackName = ""
    Trace = ""

  }


    validation {
    condition     = length(var.instance_scheduler["TagName"]) > 0 && length(var.instance_scheduler["TagName"]) < 127
    error_message = "The TagName should be between 1 and 127 chars."
  }
  validation {
    condition = (
      can(var.instance_scheduler["SendAnonymousData"]) && contains(["Yes", "No"], var.instance_scheduler["SendAnonymousData"])
    )
    error_message = "SendAnonymousData variable is required and it must be set to either \"Yes\" or \"No\"..."
  }
  validation {
    condition = (
      can(var.instance_scheduler["Trace"]) && contains(["True", "False"], var.instance_scheduler["Trace"])
    )
    error_message = "Trace variable is required and it must be set to either \"True\" or \"False\"..."
  }
  validation {
    condition = (
      can(var.instance_scheduler.MemorySize) && contains(["128","384","512","640","768","896","1024","1152","1280", "1408", "1536"], var.instance_scheduler.MemorySize)
    )
    error_message = "MemorySize should be a valid memory number like 128."
  }
  validation {
    condition = (
      can(var.instance_scheduler["SchedulerFrequency"]) && contains(["1","5","rate(5 minutes)","10","15","30","60"], var.instance_scheduler["SchedulerFrequency"])
    )
    error_message = "SchedulerFrequency should be one of 1,2,5,10,15,30,60."
  }
  validation {
    condition = (
      can(var.instance_scheduler["SchedulingActive"]) && contains(["true","false"], var.instance_scheduler["SchedulingActive"])
    )
    error_message = "SchedulingActive should be True or False."
  }
  validation {
    condition = (
      can(var.instance_scheduler.UseCloudWatchMetrics) && contains(["Yes", "No"], var.instance_scheduler.UseCloudWatchMetrics)
    )
    error_message = "Trace variable is required and it must be set to either \"Yes\" or \"No\"..."
  }
  validation {
    condition = (
      can(var.instance_scheduler.ScheduledServices) && contains(["EC2","RDS", "Both"], var.instance_scheduler.ScheduledServices)
    )
    error_message = "ScheduledServices should be EC2, RDS or Both."
  }

}


variable "Periods" {
  type = map
  default = {
    Period-1 = {
      description = "Every first monday of each quarter"
      months = "jan/3"
      name = "first-monday-in-quarter"
      type = "period"
      weekdays = "mon#1"

    }
  }
}

variable "Periods-2" {
  type = map
  default = {
    Period-2 = {
      description = "Office hours"
      name = "office-hours"
      begintime = "09:00"
      endtime = "14:50"
      type = "period"
      weekdays = "mon-fri"
    }
  }
}

variable "Periods-3" {
  type = map
  default = {
    Period-3 = {
      description = "Days in weekend"
      name = "weekends"
      type = "period"
      weekdays = "sat-sun"
    }
    Period-4 = {
      description =  "Working days"
      name = "working-days"
      type = "period"
      weekdays =  "mon-fri"
    }
  }
}


variable "Schedules" {
  type = map
  default = {
    Schedules-1 = {
      description = "Instances running"
      name = "running"
      override_status = "running"
      type = "schedule"
      use_metrics = false

    }

    Schedules-4 = {
      description = "Instances stopped"
      name = "stopped"
      override_status = "stopped"
      type = "schedule"
      use_metrics = false

    }
  }
}


variable "Schedules-2" {
  type = map
  default = {

    Schedules-2 = {
      description = "Vertical scaling on weekdays, based on UTC time"
      name = "scale-up-down"
      periods =  "weekends@t2.nano"
      timezone = "UTC"
      type = "schedule"

    }
    Schedules-3 = {
      description = "Office hours in Seattle (Pacific)"
      name = "seattle-office-hours"
      periods = "office-hours"
      timezone = "US/Pacific"
      type = "schedule"
    }

    Schedules-5 = {
      description = "Office hours in UK"
      name = "uk-office-hours"
      periods =  "office-hours"
      timezone = "Asia/Jerusalem"
      type = "schedule"
    }
  }
}