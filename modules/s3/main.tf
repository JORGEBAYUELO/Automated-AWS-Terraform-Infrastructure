resource "aws_s3_bucket" "storage" {
  bucket           = "my-terraform-bucket-s3-for-module"

  tags = {
    Name = "TerraformState"
  }
}
