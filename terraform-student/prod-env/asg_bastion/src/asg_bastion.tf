module "bastion" {
  source = "umotif-public/bastion/aws"
  version = "~> 2.1.0"

  name_prefix = "bastion-server"

  vpc_id         =  data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnets        = [
    data.terraform_remote_state.vpc.outputs.subnets_id_public[0],
    data.terraform_remote_state.vpc.outputs.subnets_id_public[1]


  ]
  # private_subnets = [
  #   data.terraform_remote_state.vpc.outputs.subnets_id_private[0],
  #   data.terraform_remote_state.vpc.outputs.subnets_id_private[1],
  #   data.terraform_remote_state.vpc.outputs.subnets_id_private[2],
  #   data.terraform_remote_state.vpc.outputs.subnets_id_private[3]
  # ]

  # hosted_zone_id = "Z1IY32BQNIYX16"
  ssh_key_name   = data.terraform_remote_state.ec2.outputs.key_pair
  bastion_instance_types = [var.general_config.ec2_size_bastion]
  volume_size = 8


  tags = {
    Project = "Terraform"
  }
}


  #   data.terraform_remote_state.vpc.outputs.subnets_id_private[0],
  #   data.terraform_remote_state.vpc.outputs.subnets_id_private[1],
  #   data.terraform_remote_state.vpc.outputs.subnets_id_private[2],
  #   data.terraform_remote_state.vpc.outputs.subnets_id_private[3]

  #     vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  # key_name = data.terraform_remote_state.ec2.outputs.key_pair