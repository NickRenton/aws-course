output "instance_profile_arn" {
  value = aws_iam_instance_profile.final_task_instance_profile.arn
}

output "instance_profile_id" {
  value = aws_iam_instance_profile.final_task_instance_profile.id
}