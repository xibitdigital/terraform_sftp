variable "bucket_name" {
  description = "The S3 bucket name"
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

variable "tags" {
  description = "Tags that will be added to the SFTP resource"
  type        = map(string)
  default     = {}
}

variable "region" {
  description = "AWS region"
  type        = string
}
