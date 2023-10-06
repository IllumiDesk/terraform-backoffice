variable "aws_region" {
  description = "The AWS region to use"
  default     = "us-east-1"
  type        = string
}

variable "aws_access_key" {
  description = "AWS access key id"
  type        = string
  default     = ""
}

variable "aws_secret_key" {
  description = "AWS secret key id"
  type        = string
  default     = ""
}

variable "aws_directory_name" {
  description = "AWS directory name"
  type        = string
  default     = "workspaces.illumidesk.com"
}

variable "workspace_size" {
  description = "Workspace size"
  default     = "Small"
  type        = string
}

variable "workspace_password" {
  description = "Workspace password"
  default     = ""
  type        = string
}
