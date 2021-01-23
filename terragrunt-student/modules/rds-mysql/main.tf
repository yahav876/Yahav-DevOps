resource "aws_db_instance" "first-db" {
  allocated_storage    = var.allocated-storage
  storage_type         = var.storage-type
  engine               = var.engine
  engine_version       = var.engine-version
  instance_class       = var.instance-class
  name                 = var.db-name
  username             = var.db-username
  password             = var.db-password
  parameter_group_name = var.db-param-group-name
  db_subnet_group_name = var.subnet-1

}
