general_config = {

  region         = "us-east-2"
  lb_state       = "lb_prod"
  backend_region = "eu-west-3"
  bastion_state  = "asg_bastion_prod"

}

db = {

  bastion_state                       = "asg_bastion"
  instance_class                      = "db.t3.medium"
  engine_version                      = "13.4"
  engine                              = "aurora-postgresql"
  allocated_storage                   = "20"
  name                                = "chat"
  username                            = "postgres"
  port                                = "5432"
  maintenance_window                  = "Sun:00:00-Sun:03:00"
  backup_window                       = "03:00-06:00"
  family                              = "aurora-postgresql13"
  major_engine_version                = "13"
  monitoring_interval                 = "30"
  identifier                          = "db-stage"
  db_instance_identifier              = "db-aurora-prod"
  password                            = "WIpn4oJgcHCkerw5xW8n"
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

  create_random_password          = false
  storage_encrypted               = true
  apply_immediately               = true
  monitoring_interval             = 10
  db_parameter_group_name         = "default"
  db_cluster_parameter_group_name = "default"
  enabled_cloudwatch_logs_exports = ["postgresql"]
  publicly_accessible             = true

  db_cluster_identifier           = "db-aurora-prod"






}

strapi = {

  instance_class                      = "db.t3.medium"
  engine_version                      = "13.4"
  engine                              = "aurora-postgresql"
  allocated_storage                   = "20"
  name                                = "strapi"
  username                            = "postgres"
  port                                = "5432"
  maintenance_window                  = "Sun:00:00-Sun:03:00"
  backup_window                       = "03:00-06:00"
  family                              = "aurora-postgresql13"
  major_engine_version                = "13"
  monitoring_interval                 = "30"
  identifier                          = "strapi-stage"
  db_instance_identifier              = "strapi-aurora-prod"
  password                            = "rn5bucZGNxmdFzYdd3yZ"
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

  create_random_password = false

  storage_encrypted               = true
  apply_immediately               = true
  monitoring_interval             = 10
  db_parameter_group_name         = "default"
  db_cluster_parameter_group_name = "default"
  enabled_cloudwatch_logs_exports = ["postgresql"]
  publicly_accessible             = true
  db_cluster_identifier           = "strapi-aurora-prod"



}


