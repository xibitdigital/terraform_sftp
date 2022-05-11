variable "bucket_name" {
  description = "The S3 bucket name"
  type        = string
}

variable "bucket_arn" {
  description = "The S3 bucket arn"
  type        = string
}

variable "transfer_server_name" {
  description = "Transfer Server name"
  type        = string
}

variable "environment" {
  description = "A name that identifies the enviroment you are deploying into"
  type        = string
}

variable "sftp_users" {
  type = map(object({
    user_name  = string,
    public_key = string
  }))

  description = "List of SFTP usernames and public keys"
}

variable "endpoint_details" {
  type = object({
    vpc_id                 = string
    subnet_ids             = list(string)
    address_allocation_ids = list(string)
    security_group_ids     = list(string)
  })
  default     = null
  description = <<-EOT
    A block required to setup internal or public facing SFTP server endpoint within a VPC
    ```{
      vpc_id                 : ID of VPC in which SFTP server endpoint will be hosted
      subnet_ids             : List of subnets ids within the VPC for hosting SFTP server endpoint
      security_group_ids     : List of security group ids
      address_allocation_ids : List of address allocation IDs to attach an Elastic IP address to your SFTP server endpoint
    }```
  EOT
}

variable "eip_enabled" {
  type        = bool
  description = "Whether to provision and attach an Elastic IP to be used as the SFTP endpoint, an EIP will be provisioned per subnet"
  default     = false
}

variable "zone_id" {
  description = "Route53 Zone ID of the SFTP Endpoint CNAME record"
  type        = string
  default     = ""
}

variable "domain_name" {
  description = "Domain name of the SFTP Endpoint as a CNAME record"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags that will be added to the SFTP resource"
  type        = map(string)
  default     = {}
}
