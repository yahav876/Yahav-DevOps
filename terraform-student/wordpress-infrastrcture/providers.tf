terraform {
  required_version = ">=0.14.8"
  backend "s3" {
    region = "us-east-1"
    profile = "default"
    key = "terraform-yahav-state"
    bucket = "terraform-yahav"
       required_providers {
    aws = {
      version = ">= 3.29.1"
      source = "hashicorp/aws"
    }
    template = {
        version = ">=2.1.2"
      }
      null = {
        version = ">=2.1.2"
      }
    }
  }
}
