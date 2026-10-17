resource "aws_s3_bucket" "lab" {
  #checkov:skip=CKV_AWS_18:Dedicated access logging is outside this demo lab scope.
  #checkov:skip=CKV_AWS_144:Single-region lab; cross-region replication is not required.
  #checkov:skip=CKV2_AWS_61:Lifecycle policy requires defined object-retention requirements.
  #checkov:skip=CKV2_AWS_62:No event-driven workload currently requires S3 notifications.
  #checkov:skip=CKV_AWS_145:AES256 encryption is sufficient for this low-cost lab.
  bucket = var.bucket_name

  tags = {
    Project     = "aws-cloud-platform-lab"
    Environment = "lab"
    ManagedBy   = "terraform"
  }
}

resource "aws_s3_bucket_versioning" "lab" {
  bucket = aws_s3_bucket.lab.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "lab" {
  bucket = aws_s3_bucket.lab.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "lab" {
  bucket = aws_s3_bucket.lab.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
