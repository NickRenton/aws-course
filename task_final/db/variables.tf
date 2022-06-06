variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "private_subnets" {
  description = "List of IDs of private subnets"
  type = list(string)
}

variable "private_subnets_cidr" {
  description = "List of CIDRs of private subnets"
  type = list(string)
}