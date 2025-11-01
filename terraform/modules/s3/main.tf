resource "aws_s3_bucket" "bkt-wattson" {
  for_each = toset(local.s3_buckets)
  # count = length(var.s3_buckets)

  bucket              = each.value
  force_destroy       = false
  object_lock_enabled = false

  tags = {
    Name = each.value
  }

}

resource "aws_s3_object" "bkt-wattson-folders" {
  for_each = toset(local.folders)

  bucket = aws_s3_bucket.bkt-wattson["bkt-wattson-client-${local.id_conta}"].id
  key = each.key
  content = ""

  depends_on = [aws_s3_bucket.bkt-wattson]
}
resource "aws_s3_bucket_policy" "bkt_policy_acesso" {
  for_each = aws_s3_bucket.bkt-wattson
  # count  = length(var.s3_buckets)

  bucket = each.value.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
        Resource  = "${each.value.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_cors_configuration" "bkt-cors-config" {
  for_each = aws_s3_bucket.bkt-wattson
  # count  = length(var.s3_buckets)

  bucket = each.value.id
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    expose_headers  = []
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_acessos" {
  for_each = aws_s3_bucket.bkt-wattson
  # count  = length(var.s3_buckets)

  bucket = each.value.id

  block_public_acls   = false
  block_public_policy = false
}
