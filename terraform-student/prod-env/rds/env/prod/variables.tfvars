general_config = {

  region              = "us-east-1"
  backend_region      = "eu-west-3"
  backend_bucket_name = "cloudteam-tf-circles"

}

db = {

  lb_state                            = "lb_qa_and_stage"
  instance_class                      = "db.t3.micro"
  engine_version                      = "11.12"
  engine                              = "postgres"
  allocated_storage                   = "20"
  name                                = "chat"
  username                            = "postgres"
  port                                = "5432"
  maintenance_window                  = "Sun:00:00-Sun:03:00"
  backup_window                       = "03:00-06:00"
  family                              = "postgres11"
  major_engine_version                = "11"
  monitoring_interval                 = "30"
  identifier                          = "db-stage"
  db_instance_identifier              = "db-stage"
  password                            = "WIpw5xW8n"
  iam_database_authentication_enabled = true
  create_db_option_group              = true
  create_db_parameter_group           = true
  create_monitoring_role              = true
  monitoring_role_name                = "MyRDSMonitoringRole-stage-db"
  skip_final_snapshot                 = true
  apply_immediately                   = true
  publicly_accessible                 = true
  first_tag_key                       = "env"
  first_tag_value                     = "stage"
  second_tag_key                      = "managedBy"
  second_tag_value                    = "terraform"
  deletion_protection                 = false
}

strapi = {

  lb_state                            = "lb_qa_and_stage"
  instance_class                      = "db.t2.micro"
  engine_version                      = "10.17"
  engine                              = "postgres"
  allocated_storage                   = "20"
  name                                = "strapi"
  username                            = "postgres"
  port                                = "5432"
  maintenance_window                  = "Sun:00:00-Sun:03:00"
  backup_window                       = "03:00-06:00"
  family                              = "postgres10"
  major_engine_version                = "10"
  monitoring_interval                 = "30"
  identifier                          = "strapi-stage"
  db_instance_identifier              = "strapi-stage"
  password                            = "rn53yZ"
  iam_database_authentication_enabled = true
  create_db_option_group              = true
  create_db_parameter_group           = true
  create_monitoring_role              = true
  monitoring_role_name                = "MyRDSMonitoringRole-stage-strapi"
  skip_final_snapshot                 = true
  apply_immediately                   = true
  publicly_accessible                 = true
  first_tag_key                       = "env"
  first_tag_value                     = "stage"
  second_tag_key                      = "managedBy"
  second_tag_value                    = "terraform"
  deletion_protection                 = false

}

