resource "aws_key_pair" "master-key" {
  key_name   = var.general_config.key_name
  public_key = file("/Users/yahavhorev/.ssh/circles-test-terraform2.pub")
}

module "bastion" {
  source = "umotif-public/bastion/aws"
  version = "~> 2.1.0"

  name_prefix = var.general_config.bastion_name

  vpc_id         =  data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnets        = [
    data.terraform_remote_state.vpc.outputs.subnets_id_public[0],
    data.terraform_remote_state.vpc.outputs.subnets_id_public[1]


  ]

  ssh_key_name   = aws_key_pair.master-key.key_name
  bastion_instance_types = [var.general_config.ec2_size_bastion]
  volume_size = 8

  # ami_id = "ami-0629230e074c580f2"
  ami_id = "ami-075c7070e2dfd4f5c" #test
  # ami_id = aws_ami.bastion.id
  userdata_file_content =  templatefile("./custom-userdata.sh", {})


  tags = {
    "${var.general_config.first_tag_key}" = "Terraform"
  }
}


resource "aws_security_group_rule" "bastion_vpn" {
  depends_on = [
    module.bastion
  ]
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "udp"
  cidr_blocks       = var.cidr_blocks
  security_group_id = module.bastion.security_group_id
}

