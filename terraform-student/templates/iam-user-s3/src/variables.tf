variable "general_config" {

    type = any
    default = {
      region              = ""
      backend_region      = ""
      backend_bucket_name = ""
  
    }
  }
  
  variable "iam_user_s3" {
  
    type = any
    default = {
      name = ""
      ingress_rules       = ""
      egress_rules        = ""
      name                = ""
      from_port_1         = ""
      to_port_1           = ""
      protocol_1          = ""
      from_port_2         = ""
      to_port_2           = ""
      protocol_2          = ""
    }
  }