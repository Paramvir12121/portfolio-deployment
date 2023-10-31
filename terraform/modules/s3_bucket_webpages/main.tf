locals {
  content_types = {
    "html" = "text/html",
    "css"  = "text/css",
    "js"   = "application/javascript",
    "jpg"  = "image/jpeg",
    # ... add more if needed
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  tags   = var.tags

}

resource "aws_s3_bucket_public_access_block" "portfolio" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "portfolio" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_acl" "portfolio" {
  depends_on = [
    aws_s3_bucket_ownership_controls.portfolio,
    aws_s3_bucket_public_access_block.portfolio,
  ]

  bucket = aws_s3_bucket.bucket.id
  acl    = "public-read"
}

# Create separate resource blocks for each file
resource "aws_s3_bucket_object" "object_code" {
  depends_on   = [aws_s3_bucket.bucket]
  for_each     = { for file in var.files_to_upload : file => file }
  bucket       = var.bucket_name
  key          = each.value
  source       = "../website_3/${each.value}"
  etag         = filemd5("../website_3/${each.value}")
  tags         = var.tags
  content_type = lookup(local.content_types, element(split(".", each.value), 1), "text/plain")
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.bucket.id
  index_document {
    suffix = var.index_document
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  depends_on = [aws_s3_bucket_object.object_code]
  bucket     = aws_s3_bucket.bucket.id
  policy     = data.aws_iam_policy_document.allow_access_from_another_account.json
}


data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.bucket.arn}/*",
    ]
  }
}

# resource "aws_s3_bucket_cors_configuration" "portflio-cors" {
#   bucket = data.aws_s3_bucket.selected-bucket.bucket
# cors_rule {
#     allowed_headers = ["Authorization", "Content-Length"]
#     allowed_methods = ["GET", "POST"]
#     allowed_origins = ["https://www.${var.domain_name}"]
#     max_age_seconds = 3000
#   }
# }
