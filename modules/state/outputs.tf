output "terraform-state-it-bucket" {
  value = aws_s3_bucket.terraform-state-it-bucket.id
}

output "aws_kms_alias_for_terraform_state" {
  value = aws_kms_alias.key-alias.name
}
