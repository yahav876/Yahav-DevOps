variable "general_config" {

  type = any
  default = {

    region              = ""
    backend_region      = ""
    backend_bucket_name = ""
    role_name           = ""
    policy_name         = ""
    user_name           = ""
    first_tag_value     = ""
    second_tag_value    = ""
    s3_bucket_name =""

  }
}

