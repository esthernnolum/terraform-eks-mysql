resource "aws_db_instance" "prophius-db" {
  allocated_storage    = 20
  db_name              = "prophius-db"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = "prophius"
  password             = "mypassword"
  parameter_group_name = "default.mysql5.7"
  vpc_security_group_ids = [var.mydb-sg-id]
  publicly_accessible =  true
  skip_final_snapshot  = true
}
 