#### Table of Contents
1. [Usage](#usage)
2. [Requirements](#requirements)
3. [Providers](#Providers)
4. [Inputs](#inputs)
5. [Outputs](#outputs)

## Usage

```
module "sftp" {
  source = "./"

  transfer_server_name       = local.transfer_server_name
  transfer_server_user_names = ["foo"]         # your username
  transfer_server_ssh_keys   = ["ssh-rsa foo"] # your rsa key, please use pbcopy and paste the content in here
  bucket_name                = aws_s3_bucket.foo_bucket.id
  bucket_arn                 = aws_s3_bucket.foo_bucket.arn

  environment = "dev"
  tags        = {
    Owner   = "Foo"
    Project = "sample"
  }
}
```

Please look in the example folder for a working sample.

To login in the sftp server please use:

```
sftp <your-username>@<created-sftp-server-endpoint>
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.31 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.57.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.57.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.sftp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_role.transfer_server_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.transfer_server_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.transfer_server_to_cloudwatch_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_transfer_server.transfer_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_server) | resource |
| [aws_transfer_ssh_key.transfer_server_ssh_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_ssh_key) | resource |
| [aws_transfer_user.transfer_server_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_user) | resource |
| [aws_iam_policy_document.transfer_server_assume_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.transfer_server_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.transfer_server_to_cloudwatch_assume_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_arn"></a> [bucket\_arn](#input\_bucket\_arn) | The S3 bucket arn | `string` | n/a | yes |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The S3 bucket name | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name of the SFTP Endpoint as a CNAME record | `string` | `""` | no |
| <a name="input_eip_enabled"></a> [eip\_enabled](#input\_eip\_enabled) | Whether to provision and attach an Elastic IP to be used as the SFTP endpoint, an EIP will be provisioned per subnet | `bool` | `false` | no |
| <a name="input_endpoint_details"></a> [endpoint\_details](#input\_endpoint\_details) | A block required to setup internal or public facing SFTP server endpoint within a VPC<pre>{<br>  vpc_id                 : ID of VPC in which SFTP server endpoint will be hosted<br>  subnet_ids             : List of subnets ids within the VPC for hosting SFTP server endpoint<br>  security_group_ids     : List of security group ids<br>  address_allocation_ids : List of address allocation IDs to attach an Elastic IP address to your SFTP server endpoint<br>}</pre> | <pre>object({<br>    vpc_id                 = string<br>    subnet_ids             = list(string)<br>    address_allocation_ids = list(string)<br>    security_group_ids     = list(string)<br>  })</pre> | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | A name that identifies the enviroment you are deploying into | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags that will be added to the SFTP resource | `map(string)` | `{}` | no |
| <a name="input_transfer_server_name"></a> [transfer\_server\_name](#input\_transfer\_server\_name) | Transfer Server name | `string` | n/a | yes |
| <a name="input_transfer_server_ssh_keys"></a> [transfer\_server\_ssh\_keys](#input\_transfer\_server\_ssh\_keys) | SSH Key(s) for transfer server user(s) | `list(string)` | n/a | yes |
| <a name="input_transfer_server_user_names"></a> [transfer\_server\_user\_names](#input\_transfer\_server\_user\_names) | User name(s) for SFTP server | `list(string)` | n/a | yes |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Route53 Zone ID of the SFTP Endpoint CNAME record | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_transfer_server_endpoint"></a> [transfer\_server\_endpoint](#output\_transfer\_server\_endpoint) | The endpoint of the Transfer Server (e.g., s-12345678.server.transfer.REGION.amazonaws.com) |
| <a name="output_transfer_server_id"></a> [transfer\_server\_id](#output\_transfer\_server\_id) | ID for an SFTP server |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
