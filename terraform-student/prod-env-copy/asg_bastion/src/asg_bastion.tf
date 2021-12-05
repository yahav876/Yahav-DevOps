# resource "aws_ami" "bastion" {
#   name                = "bastion"
#   virtualization_type = "hvm"
#   root_device_name    = "/dev/xvda"
#   ena_support         = true

#   ebs_block_device {
#     device_name = "/dev/xvda"
#     snapshot_id = data.aws_ebs_snapshot.bastion.id
#   }
# }



resource "aws_key_pair" "master-key" {
  key_name   = "terraform-circles2"
  public_key = file("/home/yahav/.ssh/circles-test-terraform2.pub")
}

module "bastion" {
  source = "umotif-public/bastion/aws"
  version = "~> 2.1.0"

  name_prefix = "bastion-server"

  vpc_id         =  data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnets        = [
    data.terraform_remote_state.vpc.outputs.subnets_id_public[0],
    data.terraform_remote_state.vpc.outputs.subnets_id_public[1]


  ]

  ssh_key_name   = aws_key_pair.master-key.key_name
  bastion_instance_types = [var.general_config.ec2_size_bastion]
  volume_size = 8

  ami_id = "ami-0629230e074c580f2"
  # ami_id = aws_ami.bastion.id
  userdata_file_content =  templatefile("./custom-userdata.sh", {})


  tags = {
    Project = "Terraform"
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
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion.security_group_id
}

