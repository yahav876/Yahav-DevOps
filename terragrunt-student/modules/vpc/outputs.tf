output "vpc_master" {
 value = aws_vpc.vpc_master.id
}

output "vpc_worker" {
  value = aws_vpc.vpc_worker_oregon.id
}

output "subnet_1" {
  value = aws_subnet.subnet_1.id
}

output "subnet_2" {
  value = aws_subnet.subnet_2.id
}


output "main_route_table_1" {
  value = aws_main_route_table_association.set-master-default-rt-assoc.id
}

output "subnet_1_oregon" {
  value = aws_subnet.subnet_1_oregon.id
}

