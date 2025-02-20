output "rds_endpoint" {
  description = "RDS dabate endpoint"
  value = aws_db_instance.default.endpoint
}
