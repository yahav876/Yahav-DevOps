variable "general_config" {

  type = any
  default = {
    name               = ""
    container_insights = ""
    capacity_providers = ""
    first_tag_key      = ""
    first_tag_value    = ""
  }
}
