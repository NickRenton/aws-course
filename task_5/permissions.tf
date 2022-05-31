resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "Enable SSH access via port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface_sg_attachment" "sg_ssh_attachment" {
  security_group_id    = aws_security_group.allow_ssh.id
  network_interface_id = aws_instance.ec2_instance_kt.primary_network_interface_id
}

resource "aws_iam_role" "task5_role" {
  name = "task5_role"

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

resource "aws_iam_policy" "sns_policy" {
  name        = "task5-sns-policy"
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
          "arn:aws:sns:us-west2:*:*",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "task5_sns_policy" {
  role       = aws_iam_role.task5_role.name
  policy_arn = aws_iam_policy.sns_policy.arn
}

resource "aws_iam_policy" "sqs_policy" {
  name        = "task5-sqs-policy"
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
          "arn:aws:sqs:us-west2:*:*",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "task5_sqs_policy" {
  role       = aws_iam_role.task5_role.name
  policy_arn = aws_iam_policy.sqs_policy.arn
}

resource "aws_iam_instance_profile" "task5_instance_profile" {
  name = "task5_instance_profile"
  role = "task5_role"
}