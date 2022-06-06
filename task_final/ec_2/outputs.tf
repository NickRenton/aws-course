output "nat_instance_id" {
  description = "The ID of a NAT instance"
  value       = aws_instance.ec2_nat_instance.id
}

output "private_ec2_ip" {
  value = aws_instance.ec2_private_instance.private_ip
}

output "http_sg_id" {
  value = aws_security_group.public_allow_http.id
  description = "The ID of a HTTP security group"
}

output "asg_id" {
  value = aws_autoscaling_group.final_task_asg.id
  description = "The ID of a ASG"
}