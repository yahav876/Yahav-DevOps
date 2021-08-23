terraform {
  required_version = ">=0.14.8"
  backend "s3" {

  }
   required_providers {
    aws = {
      version = ">= 3.29.1"
      source = "hashicorp/aws"
    }
    template = {
        version = "2.1.2"
      }
      null = {
        version = "2.1.2"
      }
    }
}
provider "aws" {
  region  = var.general_config.aws_region

}
