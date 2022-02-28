module "db" {
  source = "terraform-aws-modules/rds-aurora/aws"

  name                   = var.db.db_instance_identifier
  engine                 = var.db.engine
  engine_version         = var.db.engine_version
  instance_class         = var.db.instance_class
  master_password        = var.db.password
  master_username        = var.db.username
  create_random_password = var.db.create_random_password
  publicly_accessible    = var.db.publicly_accessible
  skip_final_snapshot    = var.db.skip_final_snapshot

  snapshot_identifier = data.aws_db_cluster_snapshot.latest_db_snapshot.id
  instances = {
    one = {}

  }

  vpc_id  = data.terraform_remote_state.vpc.outputs.vpc_id
  subnets = [data.terraform_remote_state.vpc.outputs.subnets_id_private[0], data.terraform_remote_state.vpc.outputs.subnets_id_private[1]]

  allowed_security_groups = [data.terraform_remote_state.lb.outputs.sec-group-ec2-website-stage, data.terraform_remote_state.lb.outputs.sec-group-ec2-allinone-stage, data.terraform_remote_state.bastion.outputs.bastion_sg]

  storage_encrypted   = var.db.storage_encrypted
  apply_immediately   = var.db.apply_immediately
  monitoring_interval = var.db.monitoring_interval



  enabled_cloudwatch_logs_exports = var.db.enabled_cloudwatch_logs_exports

  tags = {
    "${var.db.first_tag_key}"  = "${var.db.first_tag_value}"
    "${var.db.second_tag_key}" = "${var.db.second_tag_value}"
  }
}

module "strapi-database" {
  source = "terraform-aws-modules/rds-aurora/aws"

  name                   = var.strapi.db_instance_identifier
  engine                 = var.strapi.engine
  engine_version         = var.strapi.engine_version
  instance_class         = var.strapi.instance_class
  master_password        = var.strapi.password
  master_username        = var.strapi.username
  create_random_password = var.strapi.create_random_password
  publicly_accessible    = var.strapi.publicly_accessible
  skip_final_snapshot    = var.strapi.skip_final_snapshot

  snapshot_identifier = data.aws_db_cluster_snapshot.latest_strapi_snapshot.id


  instances = {
    one = {}

  }

  vpc_id  = data.terraform_remote_state.vpc.outputs.vpc_id
  subnets = [data.terraform_remote_state.vpc.outputs.subnets_id_private[0], data.terraform_remote_state.vpc.outputs.subnets_id_private[1]]

  allowed_security_groups = [data.terraform_remote_state.lb.outputs.sec-group-ec2-website-stage, data.terraform_remote_state.lb.outputs.sec-group-ec2-allinone-stage, data.terraform_remote_state.bastion.outputs.bastion_sg]

  storage_encrypted   = var.strapi.storage_encrypted
  apply_immediately   = var.strapi.apply_immediately
  monitoring_interval = var.strapi.monitoring_interval


  enabled_cloudwatch_logs_exports = var.strapi.enabled_cloudwatch_logs_exports

  tags = {
    "${var.strapi.first_tag_key}"  = "${var.strapi.first_tag_value}"
    "${var.strapi.second_tag_key}" = "${var.strapi.second_tag_value}"
  }
}
