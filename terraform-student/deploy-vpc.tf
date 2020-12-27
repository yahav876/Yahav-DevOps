# create VPC in us-east-1

resource "aws_vpc" "vpc_master" { #labeling it with vpc_master
  provider	        = aws.region-master
  cidr_block	        = "10.0.0.0/16"
  enable_dns_support	= true 
  enable_dns_hostnames   = true
  tags = {
   name = "master-vpc-jenkins"
 }
}
# create VPC in us-west-2

resource "aws_vpc" "vpc_worker_oregon" { #labeling it with vpc_master
  provider              = aws.region-worker
  cidr_block            = "192.168.0.0/16"
  enable_dns_support    = true
  enable_dns_hostnames   = true
  tags = {
   name = "worker-vpc-jenkins"
 }
}














# create internet GATEWAY for VPC us-east-1

resource "aws_internet_gateway" "igw" { #label igw
 provider = aws.region-master
 vpc_id = aws_vpc.vpc_master.id
}

# create internet GATEWAY for VPC us-west-2

resource "aws_internet_gateway" "igw-oregon" { #label igw-oregon
 provider = aws.region-worker
 vpc_id = aws_vpc.vpc_worker_oregon.id
}









# Get all the AZ's in the VPC for master region

data "aws_availability_zones" "azs" {
 provider = aws.region-master
 state = "available"
}








# create subnet 1 for us-east-1

resource "aws_subnet" "subnet_1" {
  provider = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id = aws_vpc.vpc_master.id
  cidr_block = "10.0.1.0/24"
}

# create subnet 2 for us-east-1

resource "aws_subnet" "subnet_2" {
  provider = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  vpc_id = aws_vpc.vpc_master.id
  cidr_block = "10.0.2.0/24"
}





# create subnet 1 for us-west-2 

resource "aws_subnet" "subnet_1_oregon" {
 provider = aws.region-worker
 vpc_id = aws_vpc.vpc_worker_oregon.id
 cidr_block = "192.168.1.0/24"
}













