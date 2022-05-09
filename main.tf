locals {
  is_vpc  = var.endpoint_details == null ? false : true
  has_eip = var.eip_enabled == true ? true : false
}

resource "aws_transfer_server" "transfer_server" {
  identity_provider_type = "SERVICE_MANAGED"
  endpoint_type          = local.is_vpc ? "VPC" : "PUBLIC"
  logging_role           = aws_iam_role.transfer_server_role.arn

  dynamic "endpoint_details" {
    for_each = local.is_vpc ? [var.endpoint_details] : []
    content {
      vpc_id                 = endpoint_details.value["vpc_id"]
      subnet_ids             = endpoint_details.value["subnet_ids"]
      security_group_ids     = endpoint_details.value["security_group_ids"]
      address_allocation_ids = local.has_eip ? aws_eip.sftp.*.id : endpoint_details.value["address_allocation_ids"]
    }
  }

  tags = {
    Name = var.transfer_server_name
  }
}

resource "aws_route53_record" "this" {
  count   = length(var.domain_name) > 0 && length(var.zone_id) > 0 ? 1 : 0
  name    = var.domain_name
  zone_id = var.zone_id
  type    = "CNAME"
  ttl     = "300"

  records = [
    aws_transfer_server.transfer_server.endpoint
  ]
}

resource "aws_eip" "sftp" {
  count = local.has_eip ? 1 : 0

  vpc = local.is_vpc
}

resource "aws_transfer_user" "transfer_server_user" {
  count = length(var.transfer_server_user_names)

  server_id      = aws_transfer_server.transfer_server.id
  user_name      = element(var.transfer_server_user_names, count.index)
  role           = aws_iam_role.transfer_server_role.arn
  home_directory = "/${var.bucket_name}"
}

resource "aws_transfer_ssh_key" "transfer_server_ssh_key" {
  count = length(var.transfer_server_user_names)

  server_id = aws_transfer_server.transfer_server.id
  user_name = element(aws_transfer_user.transfer_server_user.*.user_name, count.index)
  body      = element(var.transfer_server_ssh_keys, count.index)
}
