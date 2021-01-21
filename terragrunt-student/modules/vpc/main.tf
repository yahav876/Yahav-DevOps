resource "aws_vpc" "vpc_master" {
  cidr_block           = var.master-cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.master-vpc-name
  }
}

resource "aws_vpc" "vpc_worker_oregon" { 
  cidr_block           = var.worker-cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.worker-vpc-name
  }
}




resource "aws_internet_gateway" "igw" { 
  vpc_id   = aws_vpc.vpc_master.id
}


resource "aws_internet_gateway" "igw-oregon" { 
  vpc_id   = aws_vpc.vpc_worker_oregon.id
}



# Get all the AZ's in the VPC for master region

data "aws_availability_zones" "azs" {
#  provider = aws.region-master
  state    = "available"
}




# create subnet 1 for us-east-1

resource "aws_subnet" "subnet_1" {
 # provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc_master.id
  cidr_block        = var.subnet-1-cidr
}

# create subnet 2 for us-east-1

resource "aws_subnet" "subnet_2" {
 # provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  vpc_id            = aws_vpc.vpc_master.id
  cidr_block        = var.subnet-2-cidr
}





# create subnet 1 for us-west-2

resource "aws_subnet" "subnet_1_oregon" {
#  provider   = aws.region-worker
  vpc_id     = aws_vpc.vpc_worker_oregon.id
  cidr_block = var.subnet-1-cidr-oregon
}



# Initiate peering connection request from

resource "aws_vpc_peering_connection" "useast-1-uswest2" {
 # provider    = aws.region-master
  peer_vpc_id = aws_vpc.vpc_worker_oregon.id
  vpc_id      = aws_vpc.vpc_master.id
# peer_region = var.region-worker
}

# Accept VPC peering request in us-east-2 from us-east-1

resource "aws_vpc_peering_connection_accepter" "accept_peering" {
 # provider                  = aws.region-worker
  vpc_peering_connection_id = aws_vpc_peering_connection.useast-1-uswest2.id
  auto_accept               = true

}




# Creating Route table in us-east-1

resource "aws_route_table" "internet_route" {
 # provider = aws.region-master
  vpc_id   = aws_vpc.vpc_master.id # to which we want to route to.
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  route {
    cidr_block                = var.subnet-1-cidr-oregon 
    vpc_peering_connection_id = aws_vpc_peering_connection.useast-1-uswest2.id
  }

  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = var.rt-name-master
  }
}




## Overwrite the default route table of VPC(Master) with our route table.

resource "aws_main_route_table_association" "set-master-default-rt-assoc" {
 # provider       = aws.region-master
  vpc_id         = aws_vpc.vpc_master.id
  route_table_id = aws_route_table.internet_route.id
}






#Create route table for us-west-2

resource "aws_route_table" "internet_route_oregon" {
 # provider = aws.region-worker
  vpc_id   = aws_vpc.vpc_worker_oregon.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-oregon.id
  }
  route {
    cidr_block                = var.subnet-1-cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.useast-1-uswest2.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = var.rt-name-worker
  }
}


#Overwrite the default route table of VPC(Worker) with our route table.

resource "aws_main_route_table_association" "set-worker-default-rt-assoc" {
 # provider       = aws.region-worker
  vpc_id         = aws_vpc.vpc_worker_oregon.id
  route_table_id = aws_route_table.internet_route_oregon.id
}


