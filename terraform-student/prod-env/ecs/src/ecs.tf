module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  name = var.general_config.name

  container_insights = var.general_config.container_insights

  capacity_providers = var.general_config.capacity_providers

  tags = {
    "${var.general_config.first_tag_key}" = "${var.general_config.first_tag_value}"
  }

}

# resource "aws_ecs_task_definition" "test" {
#   family                   = "test"
#   requires_compatibilities = ["FARGATE"]
#   network_mode             = "awsvpc"
#   execution_role_arn       = "arn:aws:iam::457486133872:role/ecs-fargate-test-yahav"
#   cpu    = 1024
#   memory = 2048
#   container_definitions = jsonencode([
#     {
#       name      = "go-app"
#       image     = "457486133872.dkr.ecr.us-east-1.amazonaws.com/cloudteam:ecs-task.v1"
#       essential = true
#       # command   = ["./main"]
#       portMappings = [
#         {
#           containerPort = 8080
#       #     hostPort      = 8080
#         }
#       ]
#     },  
#   ])
# }

resource "aws_ecs_task_definition" "test" {
  family                   = "test"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  task_role_arn            = "arn:aws:iam::457486133872:role/ecs-fargate-test-yahav"
  execution_role_arn       = "arn:aws:iam::457486133872:role/ecs-fargate-test-yahav"
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "go-app",
    "image": "457486133872.dkr.ecr.us-east-1.amazonaws.com/cloudteam:ecs-task.v2",
    "cpu": 1024,
    "memory": 2048,
    "essential": true,
        "portMappings": [
      {
        "containerPort": 8080
      }
      ]
  }
]
TASK_DEFINITION
}

# data "aws_iam_role" "ecs" {
#   name = "AWSServiceRoleForECS"
# }

resource "aws_ecs_service" "mongo" {
  name            = "mediawiki-ct-ecs-test"
  cluster         = module.ecs.ecs_cluster_id
  task_definition = aws_ecs_task_definition.test.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  depends_on = [module.ecs]

  load_balancer {
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:457486133872:targetgroup/test-yahav-ecs-fragate/bf95cda1902dbb76"
    container_name   = "go-app"
    container_port   = 8080
  }

  network_configuration {

    subnets          = ["subnet-06b5f076393cbd3df", "subnet-0db0f9b11b680b0a7"]
    security_groups  = ["sg-029599ae7368ffce4"]
    assign_public_ip = true
  }
}
