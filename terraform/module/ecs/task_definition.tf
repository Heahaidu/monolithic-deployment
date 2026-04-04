resource "aws_ecs_task_definition" "frontend" {
  family = local.frontend_family

  requires_compatibilities = ["EC2"]

  network_mode = "awsvpc"
  cpu          = 1024
  memory       = 1024

  # task_role_arn = 
  # execution_role_arn = 

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = templatefile("${path.module}/json/frontend.json",
    {
      account_id = data.aws_caller_identity.current.account_id,
      aws_region = var.aws_region,
      project_name = var.project_name,
      container_port = 80,
      host_port = 80,
      health_check_url = "http://localhost/"
    }
  )

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
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = templatefile("${path.module}/json/backend.json",
    {
      account_id = data.aws_caller_identity.current.account_id,
      aws_region = var.aws_region,
      project_name = var.project_name,
      container_port = 5000,
      host_port = 80,
      health_check_url = "http://localhost:5000/",
      env = jsonencode(local.env)
    }
  )

}

data "aws_caller_identity" "current" {}
