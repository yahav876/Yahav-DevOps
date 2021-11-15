terraform {
  required_version = ">=1.0.0"
  backend "s3" {
    region  = "eu-west-3"
    profile = "default"
    key     = "terraformstatefile"
    bucket  = "cloudteam-tf"
  }
}
