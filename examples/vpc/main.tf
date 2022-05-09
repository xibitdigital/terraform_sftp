locals {
  region               = "eu-west-2"
  bucket_name          = "my-foobar-bucket-sftp"
  transfer_server_name = "sftp-server-name"

  cloudwatch_log_group_name = "vpc-flow-logs-to-cloudwatch-sftp"
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

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name           = "my-vpc"
  cidr           = "10.20.0.0/16"
  azs            = ["${local.region}a"]
  public_subnets = ["10.20.0.0/16"]
  create_igw     = true

  public_subnet_tags = {
    Name = "overridden-name-public"
  }

  # Cloudwatch log group and IAM role will be created
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60

  vpc_tags = {
    Name = "vpc-name"
  }
}

module "ssh_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/ssh"
  version = "~> 4.0"

  name                = "sftp ssh Security group"
  ingress_cidr_blocks = ["0.0.0.0/0"]
  vpc_id              = module.vpc.vpc_id
}

module "sftp" {
  source = "../../"

  transfer_server_name       = local.transfer_server_name
  transfer_server_user_names = ["foo"]         # your username
  transfer_server_ssh_keys   = ["ssh-rsa foo"] # your rsa key, please use pbcopy and paste the content in here
  bucket_name                = aws_s3_bucket.foo_bucket.id
  bucket_arn                 = aws_s3_bucket.foo_bucket.arn
  eip_enabled                = true

  endpoint_details = {
    vpc_id                 = module.vpc.vpc_id
    subnet_ids             = module.vpc.public_subnets
    security_group_ids     = [module.ssh_security_group.security_group_id]
    address_allocation_ids = []
  }
}


## Supporting resouces

# Cloudwatch logs
resource "aws_cloudwatch_log_group" "flow_log" {
  name = local.cloudwatch_log_group_name
}

resource "aws_iam_role" "vpc_flow_log_cloudwatch" {
  name_prefix        = "vpc-flow-log-role-"
  assume_role_policy = data.aws_iam_policy_document.flow_log_cloudwatch_assume_role.json
}

data "aws_iam_policy_document" "flow_log_cloudwatch_assume_role" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "vpc_flow_log_cloudwatch" {
  role       = aws_iam_role.vpc_flow_log_cloudwatch.name
  policy_arn = aws_iam_policy.vpc_flow_log_cloudwatch.arn
}

resource "aws_iam_policy" "vpc_flow_log_cloudwatch" {
  name_prefix = "vpc-flow-log-cloudwatch-"
  policy      = data.aws_iam_policy_document.vpc_flow_log_cloudwatch.json
}

data "aws_iam_policy_document" "vpc_flow_log_cloudwatch" {
  statement {
    sid = "AWSVPCFlowLogsPushToCloudWatch"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }
}
