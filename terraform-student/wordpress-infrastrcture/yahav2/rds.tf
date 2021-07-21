resource "aws_db_instance" "wp_rds" {
  count                = var.create-rds["rds"] == [""] ? 1 : 0
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = ">=5.7"
  instance_class       = "db.t3.micro"
  identifier           = "yahav-wp"
  name                 = "admin"
  username             = "admin"
  password             = "admin"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  publicly_accessible  = false
  multi_az = false
}