general_config = {

  region             = "us-east-1"
  backend_region     = "eu-west-3"
  name               = "circles-up-testing"
  container_insights = "true"
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
  first_tag_key      = "ManagedBy"
  first_tag_value    = "Terraform"

}


