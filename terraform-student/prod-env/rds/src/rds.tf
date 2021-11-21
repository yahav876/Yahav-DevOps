module "db-prod" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = "db-prod"

  engine            = var.general_config.engine_name
  engine_version    = var.general_config.db_engine_version_11_12
  instance_class    = var.general_config.db_prod_size
  allocated_storage = var.general_config.allocated_storage

  name     = var.general_config.db_name
  username = var.general_config.db_username
  password = "YourPwdShouldBeLongAndSecure!"
  port     = var.general_config.db_port

  iam_database_authentication_enabled = true

  create_db_option_group = true
  create_db_parameter_group = true

  vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.sec-group-db]

  maintenance_window = var.general_config.maintenance_window
  backup_window      = var.general_config.backup_window

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  # monitoring_interval in seconds , to disable specify 0.
  monitoring_interval = var.general_config.monitoring_interval
  monitoring_role_name = "MyRDSMonitoringRole-1"
  create_monitoring_role = true

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # DB subnet group
  subnet_ids = [data.terraform_remote_state.vpc.outputs.subnets_id_private[0], data.terraform_remote_state.vpc.outputs.subnets_id_private[1], data.terraform_remote_state.vpc.outputs.subnets_id_private[2]]

  # DB parameter group
  family = var.general_config.db_parameter_group_11

  # DB option group
  major_engine_version = var.general_config.option_engine_version_11

  # Database Deletion Protection
  deletion_protection = false

}


module "db-stage" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = "db-stage"

  engine            = var.general_config.engine_name
  engine_version    = var.general_config.db_engine_version_11_12
  instance_class    = var.general_config.db_stage_size
  allocated_storage = var.general_config.allocated_storage

  name     = var.general_config.db_name
  username = var.general_config.db_username
  password = "YourPwdShouldBeLongAndSecure!"
  port     = var.general_config.db_port

  iam_database_authentication_enabled = true

  create_db_option_group = true
  create_db_parameter_group = true

  vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.sec-group-db]

  maintenance_window = var.general_config.maintenance_window
  backup_window      = var.general_config.backup_window

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  # monitoring_interval in seconds , to disable specify 0.
  monitoring_interval = var.general_config.monitoring_interval
  monitoring_role_name = "MyRDSMonitoringRole-2"
  create_monitoring_role = true

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # DB subnet group
  subnet_ids = [data.terraform_remote_state.vpc.outputs.subnets_id_private[0], data.terraform_remote_state.vpc.outputs.subnets_id_private[1], data.terraform_remote_state.vpc.outputs.subnets_id_private[2]]

  # DB parameter group
  family = var.general_config.db_parameter_group_11

  # DB option group
  major_engine_version = var.general_config.option_engine_version_11

  # Database Deletion Protection
  deletion_protection = false

}

module "strapi-database" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = "strapi-database"

  engine            = var.general_config.engine_name
  engine_version    = var.general_config.db_engine_version_10_17
  instance_class    = var.general_config.db_strapi_size
  allocated_storage = var.general_config.allocated_storage

  name     = var.general_config.db_name
  username = var.general_config.db_username
  password = "YourPwdShouldBeLongAndSecure!"
  port     = var.general_config.db_port

  iam_database_authentication_enabled = true

  create_db_option_group = true
  create_db_parameter_group = true

  vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.sec-group-db]

  maintenance_window = var.general_config.maintenance_window
  backup_window      = var.general_config.backup_window

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  # monitoring_interval in seconds , to disable specify 0.
  monitoring_interval = var.general_config.monitoring_interval
  monitoring_role_name = "MyRDSMonitoringRole-3"
  create_monitoring_role = true

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # DB subnet group
  subnet_ids = [data.terraform_remote_state.vpc.outputs.subnets_id_private[0], data.terraform_remote_state.vpc.outputs.subnets_id_private[1], data.terraform_remote_state.vpc.outputs.subnets_id_private[2]]

  # DB parameter group
  family = var.general_config.db_parameter_group_10
  # DB option group
  major_engine_version = var.general_config.option_engine_version_10

  # Database Deletion Protection
  deletion_protection = false

}


module "strapi-database-prod" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = "strapi-database-prod"

  engine            = var.general_config.engine_name
  engine_version    = var.general_config.db_engine_version_10_17
  instance_class    = var.general_config.db_strapi_prod_size
  allocated_storage = var.general_config.allocated_storage

  name     = var.general_config.db_name
  username = var.general_config.db_username
  password = "YourPwdShouldBeLongAndSecure!"
  port     = var.general_config.db_port

  iam_database_authentication_enabled = true

  create_db_option_group = true
  create_db_parameter_group = true

  vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.sec-group-db]

  maintenance_window = var.general_config.maintenance_window
  backup_window      = var.general_config.backup_window

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  # monitoring_interval in seconds , to disable specify 0.
  monitoring_interval = var.general_config.monitoring_interval
  monitoring_role_name = "MyRDSMonitoringRole-4"
  create_monitoring_role = true

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # DB subnet group
  subnet_ids = [data.terraform_remote_state.vpc.outputs.subnets_id_private[0], data.terraform_remote_state.vpc.outputs.subnets_id_private[1], data.terraform_remote_state.vpc.outputs.subnets_id_private[2]]

  # DB parameter group
  family = var.general_config.db_parameter_group_10

  # DB option group
  major_engine_version = var.general_config.option_engine_version_10

  # Database Deletion Protection
  deletion_protection = false

}