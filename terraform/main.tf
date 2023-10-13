module "s3_bucket_webpages" {
  source                    = "./modules/s3_bucket_webpages"
  aws_region                = local.aws_region
  files_to_upload           = ["feedback.html"] # Define a list of files to upload
  bucket_name               = "feedback-form-test-1.9"
  aws_credentials_file_path = var.aws_credentials_file_path
  tags                      = local.tags
}


# module "api_gateway_lambda" {
#   source = "./modules/api_gateway_lambda"
#   #api-gateway
#   api_gateway_name        = "feedback-api"
#   api_gateway_description = "feedback-api"
#   region                  = local.aws_region
#   accountId               = file(var.accountId)
#   #lambda
#   lambda_filename = "test.zip"
#   runtime         = "python3.8"
# }

# data "archive_file" "lambda-zip" {
#   type        = "zip"
#   source_dir  = "./lambda_functions/test"
#   output_path = "test.zip"
# }

# module "dynamodb-feedback" {
#   source     = "./modules/dynamodb"
#   table_name = "Feedback-table"
# }




#Serverless with apigatewayv2 is HTTP- it is cheaper than REST
# module "lambda-apigatewayv2" {
#   source           = "./modules/lambda"
#   lambda_filename  = "test.zip"
#   function_name    = "feedback-function"
#   handler          = "main.lambda_handler"
#   runtime          = "python3.8"
#   source_code_hash = data.archive_file.lambda-zip.output_base64sha256
# }