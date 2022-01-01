module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier        = var.db.identifier
  engine            = var.db.engine
  engine_version    = var.db.engine_version
  instance_class    = var.db.instance_class
  allocated_storage = var.db.allocated_storage

  name     = var.db.name
  username = var.db.username
  password = var.db.password
  port     = var.db.port

  iam_database_authentication_enabled = var.db.iam_database_authentication_enabled
  create_db_option_group              = var.db.create_db_option_group
  create_db_parameter_group           = var.db.create_db_parameter_group

  vpc_security_group_ids = [data.terraform_remote_state.lb.outputs.sec-group-db]
  maintenance_window     = var.db.maintenance_window
  backup_window          = var.db.backup_window

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  # monitoring_interval in seconds , to disable specify 0.
  monitoring_interval    = var.db.monitoring_interval
  monitoring_role_name   = var.db.monitoring_role_name
  create_monitoring_role = var.db.create_monitoring_role

  snapshot_identifier = data.aws_db_snapshot.db.id
  skip_final_snapshot = var.db.skip_final_snapshot
  apply_immediately   = var.db.apply_immediately
  publicly_accessible = var.db.publicly_accessible

  tags = {
    "${var.db.first_tag_key}"  = var.db.first_tag_value
    "${var.db.second_tag_key}" = var.db.second_tag_value
  }

  # DB subnet group
  subnet_ids = [data.terraform_remote_state.vpc.outputs.subnets_id_private[0], data.terraform_remote_state.vpc.outputs.subnets_id_private[1], data.terraform_remote_state.vpc.outputs.subnets_id_private[2]]

  # DB parameter group
  family = var.db.family

  # DB option group
  major_engine_version = var.db.major_engine_version

  # Database Deletion Protection
  deletion_protection = var.db.deletion_protection

}

module "strapi-database" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = var.strapi.db-strapi-identifier

  engine            = var.strapi.engine
  engine_version    = var.strapi.engine_version
  instance_class    = var.strapi.instance_class
  allocated_storage = var.strapi.allocated_storage

  name     = var.strapi.name
  username = var.strapi.username
  password = var.strapi.password
  port     = var.strapi.port

  iam_database_authentication_enabled = var.strapi.iam_database_authentication_enabled

  create_db_option_group    = var.strapi.create_db_option_group
  create_db_parameter_group = var.strapi.create_db_option_group

  vpc_security_group_ids = [data.terraform_remote_state.elb.outputs.sec-group-db]

  maintenance_window = var.strapi.maintenance_window
  backup_window      = var.strapi.backup_window

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  # monitoring_interval in seconds , to disable specify 0.
  monitoring_interval    = var.strapi.monitoring_interval
  monitoring_role_name   = var.strapi.monitoring_role_name
  create_monitoring_role = var.strapi.create_monitoring_role

  snapshot_identifier = data.aws_db_snapshot.strapi-database.id
  skip_final_snapshot = var.strapi.skip_final_snapshot
  apply_immediately   = var.strapi.apply_immediately
  publicly_accessible = var.strapi.publicly_accessible

  tags = {
    "${var.strapi.first_tag_key}"  = var.strapi.first_tag_value
    "${var.strapi.second_tag_key}" = var.strapi.second_tag_value
  }

  # DB subnet group
  subnet_ids = [data.terraform_remote_state.vpc.outputs.subnets_id_private[0], data.terraform_remote_state.vpc.outputs.subnets_id_private[1], data.terraform_remote_state.vpc.outputs.subnets_id_private[2]]

  # DB parameter group
  family = var.strapi.db_parameter_group_10
  # DB option group
  major_engine_version = var.strapi.option_engine_version_10

  # Database Deletion Protection
  deletion_protection = false

}

