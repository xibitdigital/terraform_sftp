locals {
  is_vpc     = var.endpoint_details == null ? false : true
  has_eip    = var.eip_enabled == true ? true : false
  has_domain = length(var.domain_name) > 0 && length(var.zone_id) > 0 ? true : false
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

  tags = merge(local.default_tags, tomap({
    "Name" = format("%s", var.transfer_server_name)
  }))
}

resource "aws_route53_record" "this" {
  count = local.has_domain ? 1 : 0

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

# setting up users that can access the sftp server
resource "aws_transfer_user" "default" {
  for_each = var.sftp_users

  server_id = aws_transfer_server.transfer_server.id
  role      = aws_iam_role.transfer_server_role.arn
  user_name = each.value.user_name

  home_directory = "/${var.bucket_name}"

  tags = local.default_tags
}

resource "aws_transfer_ssh_key" "default" {
  for_each = var.sftp_users

  server_id = aws_transfer_server.transfer_server.id
  user_name = each.value.user_name
  body      = each.value.public_key

  depends_on = [
    aws_transfer_user.default
  ]
}
