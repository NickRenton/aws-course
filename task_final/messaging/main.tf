resource "aws_sqs_queue" "final_task_sqs" {
  name = "edu-lohika-training-aws-sqs-queue"
}

resource "aws_sns_topic" "final_task_sns" {
  name = "edu-lohika-training-aws-sns-topic"
}