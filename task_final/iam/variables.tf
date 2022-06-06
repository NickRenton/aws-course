variable "dynamo_db_arn" {
  type        = string
  description = "Name od DynamoDB table"
}

variable "s3_bucket_name" {
  default     = "kterletskyi-task-3-bucket-1"
  type        = string
  description = "S3 bucket name"
}