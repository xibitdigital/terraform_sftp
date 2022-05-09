locals {
  region               = "eu-west-2"
  bucket_name          = "my-foobar-bucket-sftp"
  transfer_server_name = "sftp-server-name"
}

provider "aws" {
  region = local.region

  default_tags {
    tags = {
      Environment = "Test"
      Owner       = "Foo"
      Project     = "sample"
    }
  }
}

resource "aws_s3_bucket" "foo_bucket" {
  bucket = local.bucket_name

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

  transfer_server_name       = local.transfer_server_name
  transfer_server_user_names = ["foo"]         # your username
  transfer_server_ssh_keys   = ["ssh-rsa foo"] # your rsa key, please use pbcopy and paste the content in here
  bucket_name                = aws_s3_bucket.foo_bucket.id
  bucket_arn                 = aws_s3_bucket.foo_bucket.arn
}
