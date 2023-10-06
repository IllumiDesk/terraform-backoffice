terraform {
  required_version = ">= 0.12"
}

resource "random_string" "suffix" {
  length  = 8
  lower   = true
  special = false
}

module "state" {
  source     = "./modules/state"
  aws_region = var.aws_region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "illumidesk-workspaces-vpc-${random_string.suffix.result}"
  cidr = "10.0.0.0/16"

  azs             = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_ipv6 = true

  enable_nat_gateway = false
  single_nat_gateway = true

  public_subnet_tags = {
    Name = "illumidesk-workspaces-public-subnet-${random_string.suffix.result}"
  }

  public_subnet_tags_per_az = {
    "${var.aws_region}a" = {
      "availability-zone" = "${var.aws_region}a"
    }
  }

  vpc_tags = {
    Name = "illumidesk-workspaces-vpc-${random_string.suffix.result}"
  }
}

resource "aws_workspaces_directory" "illumidesk" {
  directory_id = aws_directory_service_directory.illumidesk.id
  subnet_ids   = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]

  self_service_permissions {
    change_compute_type  = true
    increase_volume_size = true
    rebuild_workspace    = true
    restart_workspace    = true
    switch_running_mode  = true
  }

  workspace_access_properties {
    device_type_android    = "DENY"
    device_type_chromeos   = "ALLOW"
    device_type_ios        = "ALLOW"
    device_type_linux      = "ALLOW"
    device_type_osx        = "ALLOW"
    device_type_web        = "ALLOW"
    device_type_windows    = "ALLOW"
    device_type_zeroclient = "DENY"
  }

  workspace_creation_properties {
    custom_security_group_id            = data.aws_security_group.default.id
    default_ou                          = "OU=AWS,DC=Workspaces,DC=IllumiDesk,DC=com"
    enable_internet_access              = true
    enable_maintenance_mode             = true
    user_enabled_as_local_administrator = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.workspaces_default_service_access,
    aws_iam_role_policy_attachment.workspaces_default_self_service_access
  ]

  # Uncomment this meta-argument if you are creating the IAM resources required by the AWS WorkSpaces service.
  # depends_on = [
  #   aws_iam_role.workspaces-default
  # ]
}

resource "aws_workspaces_workspace" "illumidesk" {
  directory_id = aws_workspaces_directory.illumidesk.id
  bundle_id    = data.aws_workspaces_bundle.value_windows.id

  # Administrator is always present in a new directory.
  user_name = "Administrator"

  root_volume_encryption_enabled = true
  user_volume_encryption_enabled = true
  volume_encryption_key          = aws_kms_key.illumidesk.arn

  workspace_properties {
    compute_type_name                         = "VALUE"
    user_volume_size_gib                      = 50
    root_volume_size_gib                      = 80
    running_mode                              = "AUTO_STOP"
    running_mode_auto_stop_timeout_in_minutes = 60
  }

  tags = {
    Department = "IT"
  }

  depends_on = [
    aws_iam_role_policy_attachment.workspaces_default_service_access,
  ]
}

resource "aws_workspaces_ip_group" "main" {
  name        = "main"
  description = "Main IP access control group"

  rules {
    source = "10.10.10.10/16"
  }

  rules {
    source      = "11.11.11.11/16"
    description = "Contractors"
  }
}

resource "aws_directory_service_directory" "illumidesk" {
  name     = var.aws_directory_name
  password = var.workspace_password
  size     = var.workspace_size
  vpc_settings {
    vpc_id     = module.vpc.vpc_id
    subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
  }
}

resource "aws_kms_key" "illumidesk" {
  description             = "Used to encrypt the terraform state bucket"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}
