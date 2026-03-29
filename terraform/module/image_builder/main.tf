# (components -> )Image recipes -> Infrastructure (IAM includes SSM, EC2, ECR for instance profile) -> Distribution -> Pipeline

resource "aws_iam_role" "image_builder_role" {
  name = "${var.project_name}-image-builder-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Principal = { Service = ["ec2.amazonaws.com"] }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.image_builder_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ec2" {
  role       = aws_iam_role.image_builder_role.name
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilder"
}

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.image_builder_role.name
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
}

resource "aws_iam_instance_profile" "image_builder" {
  name = "${var.project_name}-image-builder-profile"
  role = aws_iam_role.image_builder_role.name
}

resource "aws_imagebuilder_component" "app_component" {
  name     = "${var.project_name}-app-component"
  platform = "Linux"
  version  = "1.0.0"

  data = yamlencode({
    schemaVersion = 1.0
    phases = [{
      name = "build"
      steps = [{
        name   = "UpdateYum"
        action = "ExecuteBash"
        inputs = {
          commands = [
            "sudo yum update -y"
          ]
        }
        }, {
        name   = "InstallDocker"
        action = "ExecuteBash"
        inputs = {
          commands = [
            "sudo yum install -y docker",
            "sudo systemctl enable docker",
            "sudo systemctl start docker"
          ]
        }
      }]
    }]
  })
}

resource "aws_imagebuilder_image_recipe" "app_recipe" {
  name    = "${var.project_name}-app-recipe"
  version = "1.0.0"

  parent_image = "arn:aws:imagebuilder:${var.region}:aws:image/amazon-linux-2-x86/x.x.x"

  component {
    component_arn = aws_imagebuilder_component.app_component.arn
  }
}

resource "aws_imagebuilder_infrastructure_configuration" "app_infrastructure" {
  name                  = "${var.project_name}-app-infratructure"
  instance_profile_name = aws_iam_instance_profile.image_builder.name

  instance_types = var.instance_builder_type

  subnet_id                     = element(var.public_subnet_ids[*], 0)
  security_group_ids            = var.security_group_ids
  terminate_instance_on_failure = true
}

resource "aws_imagebuilder_distribution_configuration" "app_distribution" {
  name = "${var.project_name}-app-distribution"
  distribution {
    region = var.region

    ami_distribution_configuration {
      name = "app-{{ imagebuilder:buildDate }}"

      ami_tags = {

      }
    }
  }
}

# resource "aws_imagebuilder_image_pipeline" "app_build_pipeline" {
#   name = "${var.project_name}-app-build-pipeline"

#   image_recipe_arn = aws_imagebuilder_image_recipe.app_recipe.arn

#   infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.app_infrastructure.arn

#   distribution_configuration_arn = aws_imagebuilder_distribution_configuration.app_distribution.arn

# }

resource "aws_imagebuilder_image" "app_build" {

  image_recipe_arn = aws_imagebuilder_image_recipe.app_recipe.arn

  distribution_configuration_arn = aws_imagebuilder_distribution_configuration.app_distribution.arn

  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.app_infrastructure.arn
}


