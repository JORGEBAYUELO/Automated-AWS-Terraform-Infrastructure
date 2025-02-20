output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = module.ec2.ec2_public_ip
}

output "rds_endpoint" {
  description = "RDS database endpoint"
  value       = module.rds.rds_endpoint
}

output "s3_bucket_name" {
  description = "S3 bucket nme for Terraform state"
  value       = module.s3.s3_bucket_name
}

output "dynamodb_table_name" {
  description = "DynamoDB table name used for state locking"
  value       = module.dynamodb.dynamodb_table_name
}
