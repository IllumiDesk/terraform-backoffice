<!-- BEGIN_TF_DOCS -->
# IllumiDesk Backoffice Resources

> **NOTE**: This module is still in DRAFT mode. It is not ready for production use. There is a known issue with the `aws_workspaces_directory` resource that prevents the module from deploying successfully.

Deploys an AWS Directory Service directory, a WorkSpaces directory, and a WorkSpace.

## Note

The AWS WorkSpaces service requires an IAM role named `workspaces_IllumiDeskRole`. If this role is already created, comment out the resources `aws_iam_role.workspaces_IllumiDeskRole` and `aws_iam_role_policy_attachment.workspaces_IllumiDeskRole` in the Terraform source file [iam.tf](./iam.tf).

## Usage

### Create Terraform Variables

Copy the `terraform.tfvars.example` file to `terraform.tfvars` and update the values as needed.

```shell
cp example.tfvars terraform.tfvars
```

### Terraform State

The bucket to manage state for the Workspaces is different from other IllumiDesk resources. To create the AWS S3 bucket to manage state, run the following commands:

```shell
terraform init
terraform plan -target=module.state
terraform apply -target=module.state
```

By default, resources are created in the `us-east-1` region. To override the region, set the variable `aws_region` to a different value in the `terraform.tfvars` file.

### Deploy Workspaces

Create the Workspaces resources:

```shell
terraform plan -target=module.workspaces
terraform apply -target=module.workspaces
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_state"></a> [state](#module\_state) | ./modules/state | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_directory_service_directory.illumidesk](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/directory_service_directory) | resource |
| [aws_iam_role.workspaces-default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.workspaces_default_self_service_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.workspaces_default_service_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_key.illumidesk](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_workspaces_directory.illumidesk](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspaces_directory) | resource |
| [aws_workspaces_ip_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspaces_ip_group) | resource |
| [aws_workspaces_workspace.illumidesk](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspaces_workspace) | resource |
| [random_string.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_iam_policy_document.workspaces](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_workspaces_bundle.value_windows](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/workspaces_bundle) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | AWS access key id | `string` | `""` | no |
| <a name="input_aws_directory_name"></a> [aws\_directory\_name](#input\_aws\_directory\_name) | AWS directory name | `string` | `"workspaces.illumidesk.com"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to use | `string` | `"us-east-1"` | no |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | AWS secret key id | `string` | `""` | no |
| <a name="input_workspace_password"></a> [workspace\_password](#input\_workspace\_password) | Workspace password | `string` | `""` | no |
| <a name="input_workspace_size"></a> [workspace\_size](#input\_workspace\_size) | Workspace size | `string` | `"Small"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_kms_alias_for_terraform_state"></a> [aws\_kms\_alias\_for\_terraform\_state](#output\_aws\_kms\_alias\_for\_terraform\_state) | n/a |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | List of IDs of private subnets |
| <a name="output_private_subnets_cidr_blocks"></a> [private\_subnets\_cidr\_blocks](#output\_private\_subnets\_cidr\_blocks) | List of cidr\_blocks of private subnets |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | List of IDs of public subnets |
| <a name="output_public_subnets_cidr_blocks"></a> [public\_subnets\_cidr\_blocks](#output\_public\_subnets\_cidr\_blocks) | List of cidr\_blocks of public subnets |
| <a name="output_terraform-state-it-bucket"></a> [terraform-state-it-bucket](#output\_terraform-state-it-bucket) | n/a |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | The ARN of the VPC |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
<!-- END_TF_DOCS -->