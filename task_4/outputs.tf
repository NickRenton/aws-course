output "public_ec2_id" {
  value = aws_instance.ec2_instance_kt_public.public_ip
}

output "private_ec2_id" {
  value = aws_instance.ec2_instance_kt_private.private_ip
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = concat(aws_lb.task4-lb.*.dns_name, [""])[0]
}