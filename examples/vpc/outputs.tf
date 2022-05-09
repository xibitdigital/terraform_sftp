output "transfer_endpoint" {
  description = "Endpoint for your SFTP connection"
  value       = module.sftp.transfer_server_endpoint
}

output "transfer_server_id" {
  description = "ID for an SFTP server."
  value       = module.sftp.transfer_server_id
}

output "vpc" {
  description = "VPC details."
  value       = module.vpc
}
