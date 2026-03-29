resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db_subnet_group"
  subnet_ids = [aws_subnet.private_subnet_app_3.id, aws_subnet.private_subnet_app_4.id]
}