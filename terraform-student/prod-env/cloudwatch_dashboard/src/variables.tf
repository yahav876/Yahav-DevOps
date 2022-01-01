variable "general_config" {
  type = map(any)
  default = {
    region         = ""
    backend_region = ""
    backend_bucket_name = ""
    dashboard_name = ""
    allinone_name  = ""
    website_name   = ""
    rds_state = ""

  }
}
