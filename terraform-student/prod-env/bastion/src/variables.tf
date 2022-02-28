variable "general_config" {
  type = any
  default = {
    region                 = ""
    backend_region         = ""
    backend_bucket_name    = ""
    ec2_size_bastion       = ""
    bastion_name           = ""
    first_tag_key          = ""
    first_tag_value        = ""
    key_name               = ""
    pub_key = ""
    bastion_name_tag_value = ""
    filter_ami_key = ""
    filter_ami_value = ""


  }
}

variable "cidr_blocks" {

  default = ""

}

## The value here is the name of bastion machine.
variable "filter-tags-bastion" {
  type = map(any)
  default = {
    "Name" = "bastion-server-bastion"
  }
}
