general_config = {

  region                    = "us-east-1"
  backend_region            = "eu-west-3"
  db_prod_size              = "db.t3.small"
  db_strapi_prod_size       = "db.t2.micro"
  db_stage_size             = "db.t3.micro"
  db_strapi_size            = "db.t2.micro"
  db_engine_version_10_17   = "10.17"
  db_engine_version_11_12   = "11.12"
  engine_name               = "postgres"
  allocated_storage         = "20"
  db_name                   = "test"
  db_username               = "circles_test"
  db_port                   = "5432"
  maintenance_window        = "Mon:00:00-Mon:03:00"
  backup_window             = "03:00-06:00"
  db_parameter_group_10     = "postgres10"
  db_parameter_group_11     = "postgres11"
  option_engine_version_10  = "10"
  option_engine_version_11  = "11"
  monitoring_interval       = "30"
  db-prod-identifier        = "db-prod"
  db-stage-identifier       = "db-stage"
  db-strapi-identifier      = "strapi-database"
  db-strapi-prod-identifier = "strapi-database-prod"

}


