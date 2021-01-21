terraform {

  source = "../../../modules/ec2/"
}


include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["/home/yahav/terragrunt/environments/stage/vpc", "/home/yahav/terragrunt/environments/stage/sec-group"]
}


dependency "vpc" {
  config_path = "/home/yahav/terragrunt/environments/stage/vpc"

  mock_outputs = {
    subnet_1 = "exmaple-subnet"
    main_route_table_1 = "exmaple-main-rt"
    subnet_1_oregon = "exmaple-subnet-oregon"
 }
}


dependency "sec-group" {
  config_path = "/home/yahav/terragrunt/environments/stage/sec-group"
  
  mock_outputs = { 
    sec-group-jenkins-sg = "exmaple-sec-group"
    sec_group_jenkins_sg_oregon = "exmaple-sec-group-oregon"
 }
}



inputs = {
  instance-type     = "t2.micro"
  profile           = "default"
  workers-count      = 1
  master-key-name   = "master-key"
  jenkins-master-tf = "jenkins_master_tf"
  region-worker     = "us-east-1a"
  region-master	    = "us-east-1a"


  sec-group-jenkins-sg = dependency.sec-group.outputs.sec-group-jenkins-sg
  subnet-1	       = dependency.vpc.outputs.subnet_1
  main-route-table-1   = dependency.vpc.outputs.main_route_table_1
  sec-group-jenkins-sg-oregon  = dependency.sec-group.outputs.sec_group_jenkins_sg_oregon
  subnet-1-oregon              = dependency.vpc.outputs.subnet_1_oregon

}




