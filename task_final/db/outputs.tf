output "dynamo_db_arn" {
  value = aws_dynamodb_table.kt_dynamodb_table.arn
  description = "ARN DynamoDB"
}

output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.final_task_psql_db.address
}