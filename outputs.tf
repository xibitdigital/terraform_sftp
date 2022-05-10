output "bucket_name" {
  value       = var.bucket_name
  description = "Bucket name."
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/transfer_server#endpoint
output "transfer_server_endpoint" {
  value       = try(element(concat(aws_transfer_server.transfer_server.*.endpoint, [""]), 0), "")
  description = "The endpoint of the Transfer Server (e.g., s-12345678.server.transfer.REGION.amazonaws.com)."
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/transfer_server#server_id
output "transfer_server_id" {
  value       = try(element(concat(aws_transfer_server.transfer_server.*.id, [""]), 0), "")
  description = "ID for an SFTP server."
}
