

resource "aws_launch_template" "frontend_launch_template" {
  name          = "${var.project_name}-fronend-launch-template"
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

  # user_data = base64encode({})

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
      volume_type = "gp3"
      encrypted = true
      delete_on_termination = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }

}

#
#
#

resource "aws_launch_template" "backend_launch_template" {
  name          = "${var.project_name}-backend-launch-template"
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

  # user_data = base64encode({})

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
      volume_type = "gp3"
      encrypted = true
      delete_on_termination = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }

}