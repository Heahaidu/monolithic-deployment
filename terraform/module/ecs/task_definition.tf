resource "aws_ecs_task_definition" "frontend" {
  family = local.frontend_family

  requires_compatibilities = ["EC2"]

  network_mode = "awsvpc"
  cpu          = 1024
  memory       = 1024

  # task_role_arn = 
  # execution_role_arn = 

  runtime_platform {
    cpu_architecture = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = file("${path.module}/json/frontend.json")

}

resource "aws_ecs_task_definition" "backend" {
  family = local.backend_family

  requires_compatibilities = ["EC2"]

  network_mode = "awsvpc"
  cpu          = 1024
  memory       = 1024

  # task_role_arn = 
  # execution_role_arn = 

  runtime_platform {
    cpu_architecture = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = file("${path.module}/json/backend.json")

}