output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.final_task_vpc.id
}

output "first_public_subnet_id" {
  description = "The ID of the first public subnet"
  value       = aws_subnet.final_task_first_public_subnet.id
}

output "second_public_subnet_id" {
  description = "The ID of the second public subnet"
  value       = aws_subnet.final_task_second_public_subnet.id
}

output "first_private_subnet_id" {
  description = "The ID of the first private subnet"
  value       = aws_subnet.final_task_first_private_subnet.id
}

output "second_private_subnet_id" {
  description = "The ID of the second private subnet"
  value       = aws_subnet.final_task_second_private_subnet.id
}

output "first_public_subnet_cidr" {
  description = "The CIDR of the first public subnet"
  value       = aws_subnet.final_task_first_public_subnet.cidr_block
}

output "second_public_subnet_cidr" {
  description = "The CIDR of the second public subnet"
  value       = aws_subnet.final_task_second_public_subnet.cidr_block
}

output "default_route_table_id" {
  description = ""
  value       = aws_vpc.final_task_vpc.default_route_table_id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = [aws_subnet.final_task_first_private_subnet.id, aws_subnet.final_task_second_private_subnet.id]
}

output "private_subnets_cidr" {
  description = "List of CIDRs of private subnets"
  value       = [aws_subnet.final_task_first_private_subnet.cidr_block, aws_subnet.final_task_second_private_subnet.cidr_block]
}