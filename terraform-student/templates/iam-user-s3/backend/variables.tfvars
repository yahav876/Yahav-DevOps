general_config = {

    vpc_name       = "test-circles-terraform"
    backend_region = "us-east-1"
    vpc_cidr       = "10.0.0.0/16"
    region         = "us-east-1"
  
    name = "test-yahav"
    s3_bucket_name   = "tremor-partner"
    enable_vpn_gateway   = false
    single_nat_gateway   = true
  
    first_tag_key    = "ManagedBy"
    first_tag_value  = "Terraform"
    second_tag_key   = "Environment"
    second_tag_value = "prod_qa_stage"
  
  }