# Calling EC2 module
module "ec2" {
  source = "./modules/ec2"
}

module "rds" {
  source = "./modules/rds"
}

module "s3" {
  source = "./modules/s3"
}

module "dynamodb" {
  source = "./modules/dynamodb"
}
