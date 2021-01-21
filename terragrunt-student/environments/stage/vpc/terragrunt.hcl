
terraform {

  source = "../../../modules/vpc"

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


}


