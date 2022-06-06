variable "vpc_id" {
  type        = string
  description = "VPC ID"
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

variable "second_private_subnet_id" {
  type        = string
  description = "second private subnet ID"
}

variable "nat_instance_id" {
  type        = string
  description = "NAT ID"
}

variable "default_route_table_id" {
  type        = string
  description = " ID"
}

variable "http_sg_id" {
  type        = string
  description = "Security group ID"
}

variable "asg_id" {
  type        = string
  description = "ASG ID"
}