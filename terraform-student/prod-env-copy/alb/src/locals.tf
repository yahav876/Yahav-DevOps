locals {
    
  private_subnet_id_1 = data.terraform_remote_state.vpc.outputs.subnets_id_private[0]
  private_subnet_id_2 = data.terraform_remote_state.vpc.outputs.subnets_id_private[1]
  
}