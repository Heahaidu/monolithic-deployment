resource "aws_instance" "jenkins" {
  ami                         = var.ami_id
  instance_type               = var.jenkins_instance_type
  subnet_id                   = element(var.cicd_subnet_ids[*], 0)
  vpc_security_group_ids      = var.jenkins_security_group_ids
  iam_instance_profile        = aws_iam_instance_profile.jenkins_profile.name
  associate_public_ip_address = true

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  user_data = file("${path.module}/scripts/jenkins-setup.sh")

  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = "${local.project_name}-jenkins"
  }
}