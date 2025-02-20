resource "aws_db_instance" "default" {
  allocated_storage = 20
  engine = "mysql"
  instance_class = "db.t3.micro"
  username = "admin"
  password = "phoinix123"
  publicly_accessible = false
  skip_final_snapshot = true
}
