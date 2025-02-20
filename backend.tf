terraform {
  backend "s3" {
    bucket         = "my-terraform-bucket-storage-new"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}
