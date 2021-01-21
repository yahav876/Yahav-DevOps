




generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::935393179840:role/terragrunt"
	}
  }

EOF
}


remote_state {
  
  backend = "s3"
  disable_dependency_optimization = true
  disable_init = tobool(get_env("TERRAGRUNT_DISABLE_INIT", "true"))
  generate = {
   path = "backend.tf"
   if_exists = "overwrite_terragrunt"
 }

  config = {
    bucket         = "terragrunt-yahav"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
  }
}

