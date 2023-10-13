variable "aws_credentials_file_path" {
  description = "Locate the AWS credentials file."
  type        = string

}

variable "aws_region" {
  description = "Default to US East (N. Virgínia) region."
}

#bucket & objects
variable "bucket_name" {
  type = string
}

# Define a list of files to upload
variable "files_to_upload" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

