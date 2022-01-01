variable "general_config" {
  type = map(any)
  default = {
    region              = ""
    backend_region      = ""
    backend_bucket_name = ""
    ec2_size_bastion    = ""
    bastion_name        = ""
    first_tag_key       = ""
    first_tag_value     = ""
    key_name            = ""
  }
}

variable "cidr_blocks" {
  
  default = ""
  
}