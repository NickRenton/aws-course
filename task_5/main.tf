resource "aws_instance" "ec2_instance_kt" {
  ami                  = var.AMI_ID
  instance_type        = var.ec2_instance_type
  key_name             = var.ssh_key_name
  iam_instance_profile = aws_iam_instance_profile.task5_instance_profile.id
}

resource "aws_sqs_queue" "task5_sqs_kt" {
  name = "task5_sqs"
}

resource "aws_sns_topic" "task5_sns_kt" {
  name = "task5_sns"
}