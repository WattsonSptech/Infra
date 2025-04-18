resource "aws_s3_bucket" "bkt-wattson-raw" {
  tags = {
    Name = "bkt-wattson-raw"
  }

  bucket = "bkt-wattson-raw"

  force_destroy = false

  object_lock_enabled = false
}

resource "aws_s3_bucket_policy" "bkt_policy_acesso" {
  bucket = aws_s3_bucket.bkt-wattson-raw.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "arn:aws:s3:::bkt-wattson-raw/*"
      }
    ]
  })
}

resource "aws_s3_bucket_cors_configuration" "bkt-cors-config" {
  bucket = aws_s3_bucket.bkt-wattson-raw.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    expose_headers  = []
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_acessos" {
  bucket = aws_s3_bucket.bkt-wattson-raw.bucket

  block_public_acls = false

  block_public_policy = false
}
