
terraform {

   source = "github.com:yahav876/Yahav-Student.git/terragrunt-student/modules//vpc?ref=v0.0.1"
#  source = "../../../modules/vpc"

}

include {
  path = find_in_parent_folders()
}


inputs = {

  master-cidr     = "10.0.0.0/16"
  worker-cidr     = "192.168.0.0/16"
  master-vpc-name = "yahav"
  worker-vpc-name = "shlomi"

  subnet-1-cidr   = "10.0.1.0/24"
  subnet-2-cidr   = "10.0.2.0/24"

  subnet-1-cidr-oregon = "192.168.1.0/24"

#  region-worker   = "us-east-1"

  rt-name-master  = "Master-region-RT"
  rt-name-worker  = "Worker-region-RT"

  vpc-master-id   = "aws_vpc.vpc_master.id"
  vpc-worker-id   = "aws_vpc.vpc_worker_oregon.id"

}


