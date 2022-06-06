resource "aws_iam_role" "final_task_role" {
  name = "final_task_role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Sid       = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "final_task_instance_profile" {
  name = "final_task_instance_profile"
  role = "final_task_role"
}

resource "aws_iam_policy" "dynamodb_policy" {
  name   = "dynamodb_policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["dynamodb:*"],
        "Resource" : var.dynamo_db_arn
      }
    ]
  })
}

resource "aws_iam_policy" "sns_policy" {
  name        = "final_task_sns_policy"
  description = "Allow "

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "SNS:*"
        ],
        "Resource" : [
          "*",
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "sqs_policy" {
  name        = "final_task_sqs_policy"
  description = "Allow "

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor1",
        "Effect" : "Allow",
        "Action" : [
          "SQS:*"
        ],
        "Resource" : [
          "*",
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "bucket_policy" {
  name        = "final_bucket_policy"
  path        = "/"
  description = "Allow "

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ],
        "Resource" : [
          "arn:aws:s3:::*/*",
          "arn:aws:s3:::${var.s3_bucket_name}"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "final_task_sqs_policy" {
  role       = aws_iam_role.final_task_role.name
  policy_arn = aws_iam_policy.sqs_policy.arn
}

resource "aws_iam_role_policy_attachment" "final_task_sns_policy" {
  role       = aws_iam_role.final_task_role.name
  policy_arn = aws_iam_policy.sns_policy.arn
}

resource "aws_iam_role_policy_attachment" "final_task_dynamodb_policy" {
  role       = aws_iam_role.final_task_role.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}

resource "aws_iam_role_policy_attachment" "final_bucket_policy" {
  role       = aws_iam_role.final_task_role.name
  policy_arn = aws_iam_policy.bucket_policy.arn
}