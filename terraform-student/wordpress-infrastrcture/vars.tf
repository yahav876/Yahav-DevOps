variable "profile" {
  type    = string
  default = "default"
}

variable "region-master" {
  type    = string
  default = "us-east-1"
}


variable "buckets-num" {
  type = map(any)
  default = {

    bucket  = [""]
    bucket2 = [""]
  }
}
variable "cloudfront" {
  type = map
  default = {
    cdn   =  [""]
    cdn2  = [""]
  }
}
variable "s3-tags" {
  description = "Map of project names to configuration."
  type        = map
  default     = {
    client-webapp = {
      public_subnets_per_vpc  = 2,
    },
    internal-webapp = {
      public_subnets_per_vpc  = 1,
    }
  }
}

variable "create-sg" {
  default = {
    sg    = [""]
    sg2   = [""]
  }
}


