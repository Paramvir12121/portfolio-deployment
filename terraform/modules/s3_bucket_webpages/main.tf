locals {
  content_types = {
    "html" = "text/html",
    "css"  = "text/css",
    "js"   = "application/javascript"
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
resource "aws_s3_bucket_object" "object" {
  depends_on   = [aws_s3_bucket.bucket]
  for_each     = { for file in var.files_to_upload : file => file }
  bucket       = var.bucket_name
  key          = each.value
  source       = "../website_3/${each.value}"
  etag         = filemd5("../website_3/${each.value}")
  tags         = var.tags
  content_type = lookup(local.content_types, element(split(".", each.value), 1), "text/plain")
#  Code explained:
# each.value:
# each.value is part of the Terraform for_each loop. In the context of the aws_s3_bucket_object resource, each.value represents the current item (in this case, the filename) being processed from the files_to_upload list.
# split(".", each.value):

# The split() function takes two arguments: a delimiter and a string. Here, it splits the filename (each.value) wherever there's a period (".").
# For instance, if each.value is "script.js", the result of this split operation is a list with two elements: ["script", "js"].
# element(split(".", each.value), 1):

# The element() function fetches an element from a list by its index.
# After splitting, if you want to get the file extension, you'd need the second element of the list (recall that indexing is zero-based, so the second element's index is 1).
# Continuing the above example, the result of element(split(".", "script.js"), 1) would be "js".
# lookup(local.content_types, ..., "text/plain"):

# The lookup() function retrieves the value of a map based on a given key. It takes three arguments: the map, the key to look up, and a default value to return if the key is not found in the map.
# Here, it's looking up the appropriate Content-Type from the local.content_types map based on the file extension determined in the previous step.
# If the extension is not found in the map, the function will return the default value "text/plain".
# Putting it all together:
# This code is setting the content_type attribute for the S3 object based on the file extension of the current file (each.value) being processed. It looks up the appropriate Content-Type from a predefined map (local.content_types). If the file extension isn't recognized, it defaults to "text/plain".

}



resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.bucket.id
  index_document {
    suffix = var.index_document
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  depends_on = [aws_s3_bucket_object.object]
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
