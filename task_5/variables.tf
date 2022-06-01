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