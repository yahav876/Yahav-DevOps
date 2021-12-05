variable "general_config" {
  type = map(any)
  default = {
    region               = ""
    backend_region       = ""
    ec2_size_bastion     = ""
    s3_bucket_name       = ""
    launch_template_name = ""



  }
}
