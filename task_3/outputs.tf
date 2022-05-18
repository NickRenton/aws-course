output "public_id" {
  value = aws_instance.ec2_instance_kt.public_ip
}

output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.task3_db.address
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.task3_db.port
}