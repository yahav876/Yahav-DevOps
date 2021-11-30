resource "aws_ami" "all-in-one-stage" {
  name                = "all-in-one-stage"
  virtualization_type = "hvm"
  root_device_name    = "/dev/xvda"
  ena_support         = true

  ebs_block_device {
    device_name = "/dev/xvda"
    snapshot_id = data.aws_ebs_snapshot.all-in-one-stage.id
  }
}

resource "aws_ami" "website-stage" {
  name                = "website-stage"
  virtualization_type = "hvm"
  root_device_name    = "/dev/xvda"
  ena_support         = true

  ebs_block_device {
    device_name = "/dev/xvda"
    snapshot_id = data.aws_ebs_snapshot.website-stage.id
  }
}





module "ec2_instance_3" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "all_in_one-test"

  ami                    = aws_ami.all-in-one-stage.id
  instance_type          = var.general_config.ec2_size
  key_name               = data.terraform_remote_state.asg_bastion.outputs.key_pair
  monitoring             = true
  vpc_security_group_ids = [data.terraform_remote_state.elb.outputs.sec-group-ec2]
  subnet_id              = data.terraform_remote_state.vpc.outputs.subnets_id_private[2]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "ec2_instance_4" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "website-test"

  ami                    = aws_ami.website-stage.id
  instance_type          = var.general_config.ec2_size
  key_name               =  data.terraform_remote_state.asg_bastion.outputs.key_pair
  monitoring             = true
  vpc_security_group_ids = [data.terraform_remote_state.elb.outputs.sec-group-ec2]
  subnet_id              = data.terraform_remote_state.vpc.outputs.subnets_id_private[3]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

