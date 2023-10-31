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

variable "files_to_upload" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

variable "index_document" {
  type = string
}