variable "general_config" {
  type = map(any)
  default = {
    region         = ""
    lb_state       = ""
    backend_region = ""
    bastion_state  = ""
  }
}

variable "db" {
  type = any
  default = {
    region                         = ""
    lb_state                       = ""
    backend_region                 = ""
    db_prod_size                   = ""
    db_strapi_prod_size            = ""
    db_stage_size                  = ""
    db_strapi_size                 = ""
    db_engine_version_10_17        = ""
    db_engine_version_11_12        = ""
    engine_name                    = ""
    allocated_storage              = ""
    db_name                        = ""
    db_strapi_name                 = ""
    db_username                    = ""
    db_port                        = ""
    maintenance_window             = ""
    backup_window                  = ""
    db_parameter_group_10          = ""
    db_parameter_group_11          = ""
    option_engine_version_10       = ""
    option_engine_version_11       = ""
    monitoring_interval            = ""
    db-prod-identifier             = ""
    db-stage-identifier            = ""
    db-strapi-identifier           = ""
    db-strapi-prod-identifier      = ""
    db-prod-identifier-snap        = ""
    db-stage-identifier-snap       = ""
    db-strapi-identifier-snap      = ""
    db-strapi-prod-identifier-snap = ""

    instance_class                  = ""
    storage_encrypted               = ""
    apply_immediately               = ""
    monitoring_interval             = ""
    db_parameter_group_name         = ""
    db_cluster_parameter_group_name = ""
    enabled_cloudwatch_logs_exports = ""

    db_cluster_identifier = ""


  }
}

variable "strapi" {
  type = any
  default = {
    region                         = ""
    lb_state                       = ""
    backend_region                 = ""
    db_prod_size                   = ""
    db_strapi_prod_size            = ""
    db_stage_size                  = ""
    db_strapi_size                 = ""
    db_engine_version_10_17        = ""
    db_engine_version_11_12        = ""
    engine_name                    = ""
    allocated_storage              = ""
    db_name                        = ""
    db_strapi_name                 = ""
    db_username                    = ""
    db_port                        = ""
    maintenance_window             = ""
    backup_window                  = ""
    db_parameter_group_10          = ""
    db_parameter_group_11          = ""
    option_engine_version_10       = ""
    option_engine_version_11       = ""
    monitoring_interval            = ""
    db-prod-identifier             = ""
    db-stage-identifier            = ""
    db-strapi-identifier           = ""
    db-strapi-prod-identifier      = ""
    db-prod-identifier-snap        = ""
    db-stage-identifier-snap       = ""
    db-strapi-identifier-snap      = ""
    db-strapi-prod-identifier-snap = ""

    instance_class                  = ""
    storage_encrypted               = ""
    apply_immediately               = ""
    monitoring_interval             = ""
    db_parameter_group_name         = ""
    db_cluster_parameter_group_name = ""
    enabled_cloudwatch_logs_exports = ""

    db_cluster_identifier = ""


  }
}

variable "subnets_id" {
  type    = string
  default = ""
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "filter-tags-db" {
  type = map(any)
  default = {
    "Name" = ""
  }
}

variable "filter-tags-strapi" {
  type = map(any)
  default = {
    "Name" = ""
  }
}