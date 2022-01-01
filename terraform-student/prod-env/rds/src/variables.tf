variable "general_config" {
  type = map(any)
  default = {
    region         = ""
    lb_state       = ""
    backend_region = ""
  }
}

variable "db" {
  type = map(any)
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

  }
}

variable "strapi" {
  type = map(any)
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
