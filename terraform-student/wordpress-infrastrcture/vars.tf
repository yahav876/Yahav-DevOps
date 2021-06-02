variable "profile" {
  type    = string
  default = "default"
}

variable "region-master" {
  type    = string
  default = "us-east-1"
}

variable "buckets-num" {
1 = {
    bukcet =  [""]
    bucket2 = [""]
   }
}

variable "bucket-name" {
  type    = list
  default = ["mdeia-yahav", "code-yahav" ]
}

variable "instance-type" {
  type    = string
  default = "t3.micro"
}
variable "webserver-port" {
  type    = number
  default = 80
}
variable "dns-name" {
  type    = string
  default = "yahavhorev.com."
}
