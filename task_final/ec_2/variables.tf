variable "ami_nat_id" {
  default     = "ami-0032ea5ae08aa27a2"
  type        = string
  description = "AMI NAT ID"
}

variable "ec2_instance_type" {
  default     = "t2.micro"
  type        = string
  description = "EC2 instance type"
}

variable "ssh_key_name" {
  default     = "aws-key-mac-2019"
  type        = string
  description = "SSH key name"
}

variable "ami_id" {
  default     = "ami-00ee4df451840fa9d"
  type        = string
  description = "AMI ID"
}

variable "first_public_subnet_id" {
  type        = string
  description = "first public subnet ID"
}

variable "second_public_subnet_id" {
  type        = string
  description = "second public subnet ID"
}

variable "first_private_subnet_id" {
  type        = string
  description = "first private subnet ID"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "first_public_cidr" {
  type        = string
  description = "second public subnet CIDR"
}

variable "second_public_cidr" {
  type        = string
  description = "second public subnet CIDR"
}

variable "instance_profile_arn" {
  type        = string
  description = "Instance profile ARN"
}

variable "instance_profile_id" {
  type        = string
  description = "Instance profile ID"
}

variable "s3_bucket_name" {
  default     = "kterletskyi-task-3-bucket-1"
  type        = string
  description = "S3 bucket name"
}

variable "rds_hostname" {
  type        = string
  description = "RDS host name"
}