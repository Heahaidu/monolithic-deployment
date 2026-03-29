output "ami_id" {
  value = aws_imagebuilder_image.app_build.output_resources[0].amis[0].image
}