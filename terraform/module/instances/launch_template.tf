

resource "aws_launch_template" "launch_template" {
  name          = "${var.project_name}-ecs-launch-template"
  image_id      = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile.name
  }

  network_interfaces {
    security_groups = var.instance_security_group_ids
    subnet_id = element(var.instance_subnet_ids[*], 0)
    associate_public_ip_address = false
  }

  user_data = base64encode(templatefile("${path.module}/scripts/launch-template.sh"))

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 40
      volume_type = "gp3"
      encrypted = true
      delete_on_termination = true
    }
  }

}