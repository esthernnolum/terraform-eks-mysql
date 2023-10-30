# Create an Amazon RDS MySQL database
resource "aws_db_instance" "mydb_instance" {
  identifier             = var.mydbinstance_identifier
  engine                 = "mysql"
  instance_class         = "db.t2.micro"
  allocated_storage      = 20
  username               = var.mydbinstance_username
  password               = var.mydbinstance_password
  vpc_security_group_ids = [var.db-sg-id]
  publicly_accessible    = false
  skip_final_snapshot    = true
}
