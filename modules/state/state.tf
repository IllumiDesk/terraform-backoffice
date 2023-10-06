resource "aws_kms_key" "terraform-state-it-bucket" {
 description             = "Used to encrypt the terraform state bucket"
 deletion_window_in_days = 10
 enable_key_rotation     = true
}

resource "aws_kms_alias" "key-alias" {
 name          = "alias/illumidesk-terraform-bucket-key"
 target_key_id = aws_kms_key.terraform-state-it-bucket.key_id
}

resource "aws_s3_bucket" "terraform-state-it-bucket" {
    bucket = "terraform-state-it-bucket"
    logging {
      target_bucket = aws_s3_bucket.terraform-state-it-bucket-logging.id
      target_prefix = "log/"
    }

    tags = {
        Name = "S3 Remote Terraform State Store"
    }
}

resource "aws_s3_bucket" "terraform-state-it-bucket-logging" {
    bucket = "terraform-state-it-bucket-logging"
    tags = {
        Name = "S3 bucket for logging terraform state bucket"
    }
}

resource "aws_s3_bucket_public_access_block" "block" {
 bucket = aws_s3_bucket.terraform-state-it-bucket.id

 block_public_acls       = true
 block_public_policy     = true
 ignore_public_acls      = true
 restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.terraform-state-it-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform-state-it-bucket" {
  bucket = aws_s3_bucket.terraform-state-it-bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.terraform-state-it-bucket.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
