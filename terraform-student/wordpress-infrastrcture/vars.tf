variable "profile" {
  type    = string
  default = "default"
}

variable "region-master" {
  type    = string
  default = "us-east-1"
}

variable "buckets-num" {
  1 {
        bukcet = [""]
}

}

variable "workers-count" {
  type    = number
  default = 1
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
