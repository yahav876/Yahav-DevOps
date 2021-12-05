general_config = {
    
    region = "us-east-2"
    backend_region = "eu-west-3"
    lb_name = "circles-up-test-terraform"
    vpc_cidr         = "10.0.0.0/16"

}

sec_group = {

    website-stage = "ec2-sec-group-website-stage"
    all-in-one-stage = "ec2-sec-group-allinone-stage"
    website-prod = "ec2-sec-group-website-prod"
    all-in-one-prod = "ec2-sec-group-all-in-one-prod"
    db-sec-group = "db-sec-group"


}



# private_subnets_lb = {

#     subnet-a = "10.0.1.0/24"
#     subnet-b = "10.0.2.0/24"

#     }

# private_subnets_lb = 

#     default = 

# }

#      "10.0.1.0/24"  

#     "10.0.1.0/24"  

    


