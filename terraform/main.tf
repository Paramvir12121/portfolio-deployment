module "s3_bucket_webpages" {
  source          = "./modules/s3_bucket_webpages"
  aws_region      = local.aws_region
  # List of files to upload
  files_to_upload = ["index.html", "styles.css", "scripts.js", "assets/img/profile.jpg"] 
  bucket_name               = "param-portfolio-1.0.12"
  aws_credentials_file_path = var.aws_credentials_file_path
  index_document            = "index.html"
  tags                      = local.tags
}


