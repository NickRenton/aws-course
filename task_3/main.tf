terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 1.1.0"
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name                 = "task3VPC"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Enable SSH access via port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow HTTP to client host"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "task3_s3_role" {
  name = "task3_s3_role"

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

resource "aws_iam_policy" "bucket_policy" {
  name        = "task3-bucket-policy"
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

resource "aws_iam_policy" "dynamodb_policy" {
  name   = "dynamodb_policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["dynamodb:*"],
        "Resource" : aws_dynamodb_table.kt_dynamodb_table.arn
      }
    ]
  })
}

resource "aws_iam_instance_profile" "task3_instance_profile" {
  name = "task3_instance_profile"
  role = "task3_s3_role"
}

resource "aws_network_interface_sg_attachment" "sg_ssh_attachment" {
  security_group_id    = aws_security_group.allow_ssh.id
  network_interface_id = aws_instance.ec2_instance_kt.primary_network_interface_id
}

resource "aws_network_interface_sg_attachment" "sg_http_attachment" {
  security_group_id    = aws_security_group.allow_http.id
  network_interface_id = aws_instance.ec2_instance_kt.primary_network_interface_id
}

resource "aws_iam_role_policy_attachment" "cloud_watch_policy" {
  role       = aws_iam_role.task3_s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "task3_bucket_policy" {
  role       = aws_iam_role.task3_s3_role.name
  policy_arn = aws_iam_policy.bucket_policy.arn
}

resource "aws_iam_role_policy_attachment" "task3_dynamodb_policy" {
  role       = aws_iam_role.task3_s3_role.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}

resource "aws_dynamodb_table" "kt_dynamodb_table" {
  name           = "Music"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "Band"
  range_key      = "Song"

  attribute {
    name = "Band"
    type = "S"
  }

  attribute {
    name = "Song"
    type = "S"
  }
}

resource "aws_db_subnet_group" "task3_subnet_group" {
  name       = "task3sg"
  subnet_ids = module.vpc.public_subnets

  tags = {
    Name = "Education"
  }
}
resource "aws_db_parameter_group" "task3_pg" {
  name   = "task3pg"
  family = "postgres13"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}
resource "aws_db_instance" "task3_db" {
  identifier             = "task3db"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "13.4"
  username               = "kterletskyi"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.task3_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  parameter_group_name   = aws_db_parameter_group.task3_pg.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}

resource "aws_security_group" "rds_sg" {
  name   = "task3_rds_sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "task3_rds_sg"
  }
}

resource "aws_instance" "ec2_instance_kt" {
  ami                  = var.AMI_ID
  instance_type        = var.ec2_instance_type
  key_name             = var.ssh_key_name
  iam_instance_profile = aws_iam_instance_profile.task3_instance_profile.id
  user_data            = file("download.sh")
  subnet_id            = module.vpc.public_subnets[0]
}

resource "aws_vpc_endpoint" "dynamodb_vpc_endpoint" {
  vpc_id          = module.vpc.vpc_id
  service_name    = "com.amazonaws.us-west-2.dynamodb"
  route_table_ids = [module.vpc.default_route_table_id]
}
