terraform {
  required_version = ">=0.14.0"
  backend "s3" {
    region = "us-east-1"
    profile = "default"
    key = "terraform-yahav-state"
    bucket = "terraform-yahav"
  }
}