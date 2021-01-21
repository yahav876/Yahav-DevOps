terraform {

  source = "../../../modules/sec-group/"
}


include {
  path = find_in_parent_folders()
}


dependency "vpc" {
  config_path = "/home/yahav/terragrunt/environments/stage/vpc"

  mock_outputs = { 
    vpc_master = "vpc-temporay-id"
    vpc_worker = "vpc-temporary-id-worker"
 } 

}





inputs = {
  lb-sg-name                    = "load-balancer-secgroup"
  lb-sg-description             = "Only TCP 443/80 and outbound access"
  lb-sg-ingress-description-1   = "master-key"
  from-port-lb-1                = "443"
  to-port-lb-1                  = "443"
  from-port-lb-2                = "80"
  to-port-lb-2                  = "80"
  

  master-sg-name		  = "Jenkins-master-secgroup"
  from-port-master-1		  = "22"
  to-port-master-1       	  = "22"
  from-port-master-2              = "80"
  to-port-master-2                = "80"
  external-ip			  = "0.0.0.0/0"
  master-cidr			  = "192.168.1.0/24"


  worker-sg-name                  = "Jenkins-worker-secgroup"
  from-port-worker-1              = "22"
  to-port-worker-1                = "22"
  from-port-worker-2              = "0"
  to-port-worker-2                = "0"
  worker-cidr			  = "10.0.1.0/24"


 master-vpc-id  = dependency.vpc.outputs.vpc_master
 worker-vpc-id  = dependency.vpc.outputs.vpc_worker


}



