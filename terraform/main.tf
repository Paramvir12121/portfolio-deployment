module "s3_bucket_webpages" {
  source                    = "./modules/s3_bucket_webpages"
  aws_region                = local.aws_region
  files_to_upload           = ["index.html"] # Define a list of files to upload
  bucket_name               = "param-portfolio-1.0.9"
  aws_credentials_file_path = var.aws_credentials_file_path
  index_document            = "index.html"
  tags                      = local.tags
}


