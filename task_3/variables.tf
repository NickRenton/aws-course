variable "ec2_instance_type" {
  default     = "t2.micro"
  type        = string
  description = "EC2 instance type"
}

variable "AMI_ID" {
  default     = "ami-00ee4df451840fa9d"
  type        = string
  description = "AMI ID"
}

variable "ssh_key_name" {
  default     = "aws-key-mac-2019"
  type        = string
  description = "SSH key name"
}

variable "s3_bucket_name" {
  default     = "kterletskyi-task-3-bucket-1"
  type        = string
  description = "S3 bucket name"
}

variable "db_password" {
  default     = "roronoa_zoro"
  description = "RDS root user password"
  sensitive   = true
}

variable "cidr_block" {
  default = "10.0.0.0/16"
  type    = string
}

variable "subnet" {
  default = "10.0.0.0/24"
  type    = string
}

variable "aws_availability_zone" {
  type    = string
  default = "us-west-2c"
}