provider "aws" {
  profile = "default"
  region  = "us-east-1"
  alias   = "region-master"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
  alias   = "region-worker"
}
