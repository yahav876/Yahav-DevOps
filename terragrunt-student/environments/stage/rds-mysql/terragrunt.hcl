terraform {

  source = "../../../modules/rds-mysql"
}


include {
  path = find_in_parent_folders()
}

#dependencies {
#  paths = ["/home/yahav/terragrunt/environments/stage/vpc", "/home/yahav/terragrunt/environments/sta#ge/sec-group"]
#}


dependency "vpc" {
  config_path = "../../../environments/stage/vpc"

  mock_outputs = {
    subnet_1 = "exmaple-subnet"
#    main_route_table_1 = "exmaple-main-rt"
#    subnet_1_oregon = "exmaple-subnet-oregon"
 }
}


#dependency "sec-group" {
#  config_path = "/home/yahav/terragrunt/environments/stage/sec-group"
#  
#  mock_outputs = { 
#    sec-group-jenkins-sg = "exmaple-sec-group"
#    sec_group_jenkins_sg_oregon = "exmaple-sec-group-oregon"
# }
#}



inputs = {
  allocated-storage      = "20"
  storage-type           = "gp2"
  engine                 = "mysql"
  engine-version         = "8.0.20"
  instance-class         = "db.t2.micro"
  db-name                = "first-db"
  db-username            = "example"
  db-password            = "examplepass"
  db-param-group-name    = "param-group"


  subnet-1		 = dependency.vpc.outputs.subnet_1
#  subnet-1	       = dependency.vpc.outputs.subnet_1
#  main-route-table-1   = dependency.vpc.outputs.main_route_table_1
#  sec-group-jenkins-sg-oregon  = dependency.sec-group.outputs.sec_group_jenkins_sg_oregon
#  subnet-1-oregon              = dependency.vpc.outputs.subnet_1_oregon

}


