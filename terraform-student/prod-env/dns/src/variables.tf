variable "general_config" {
  type = map(any)
  default = {
    zone_2              = ""
    zone_1              = ""
    region              = ""
    backend_region      = ""
    backend_bucket_name = ""

  }
}
