variable "general_config" {
  type = map(any)
  default = {
    region                   = ""
    backend_region           = ""
    db_prod_size             = ""
    db_strapi_prod_size      = ""
    db_stage_size            = ""
    db_strapi_size           = ""
    db_engine_version_10_17  = ""
    db_engine_version_11_12  = ""
    engine_name              = ""
    allocated_storage        = ""
    db_name                  = ""
    db_username              = ""
    db_port                  = ""
    maintenance_window       = ""
    backup_window            = ""
    db_parameter_group_10    = ""
    db_parameter_group_11    = ""
    option_engine_version_10 = ""
    option_engine_version_11 = ""
    monitoring_interval      = ""

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
