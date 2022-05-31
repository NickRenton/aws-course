output "public_id" {
  value = aws_instance.ec2_instance_kt.public_ip
}

output "sns_topic_arn" {
  description = "SNS topic ARN"
  value       = aws_sns_topic.task5_sns_kt.arn
}

output "sqs_url" {
  description = "SQS URL"
  value       = aws_sqs_queue.task5_sqs_kt.url
}