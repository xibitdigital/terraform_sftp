provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = "Test"
      Owner       = "Foo"
      Project     = "sample"
    }
  }
}

resource "aws_s3_bucket" "foo_bucket" {
  bucket = var.bucket_name

  tags = {
    Name = "My bucket"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.foo_bucket.id
  acl    = "private"
}

module "sftp" {
  source = "../../"

  transfer_server_name = var.transfer_server_name
  sftp_users           = var.sftp_users
  bucket_name          = aws_s3_bucket.foo_bucket.id
  bucket_arn           = aws_s3_bucket.foo_bucket.arn

  environment = var.environment
  tags        = var.tags
}
