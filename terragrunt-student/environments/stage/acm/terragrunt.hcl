terraform {

  source = "../../../modules/acm/"
}


include {
  path = find_in_parent_folders()
}


dependencies {
  paths = ["/home/yahav/terragrunt/environments/stage/sec-group", "/home/yahav/terragrunt/environments/stage/vpc", "/home/yahav/terragrunt/environments/stage/ec2"]
}


dependency "sec-group" {
  config_path = "/home/yahav/terragrunt/environments/stage/sec-group"

  mock_outputs = {
   sec_group_lb = "example-sec-group"
 }
}




dependency "vpc" {
  config_path = "/home/yahav/terragrunt/environments/stage/vpc"

  mock_outputs = {
   subnet_1 = "9.9.9.9"
   subnet_2 = "0.0.0.0"
   vpc_master = "master-exmaple"
 }
}



dependency "ec2" {
  config_path = "/home/yahav/terragrunt/environments/stage/ec2"
}





inputs = {
  data-dns-name	       = "yahavhorev.com."
  domain-name          = "jenkins"
  acm-name             = "Jenkins-ACM"
  lb-name	       = "jenkins-lb"
  lb-type	       = "application"
  webserver-port       = "80" 
  target-type	       = "instance"
  record-type	       = "A"
  lb-tg-name	       = "jenkins-tg"


  sec-group-lb      = dependency.sec-group.outputs.sec_group_lb
  subnet-1          = dependency.vpc.outputs.subnet_1
  subnet-2          = dependency.vpc.outputs.subnet_2
  vpc-master        = dependency.vpc.outputs.vpc_master
  jenkins-master-id = dependency.ec2.outputs.jenkins_master_id


}

