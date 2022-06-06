resource "aws_dynamodb_table" "kt_dynamodb_table" {
  name           = "edu-lohika-training-aws-dynamodb"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "UserName"

  attribute {
    name = "UserName"
    type = "S"
  }
}

resource "aws_db_parameter_group" "final_task_parameter_group" {
  name   = "finaltaskpg"
  family = "postgres13"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_subnet_group" "final_task_subnet_group" {
  name       = "final_task_subnet_group"
  subnet_ids = var.private_subnets
}

resource "aws_db_instance" "final_task_psql_db" {
  identifier             = "finaltaskdb"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "13.4"
  username               = "rootuser"
  password               = "rootuser"
  db_subnet_group_name   = aws_db_subnet_group.final_task_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  parameter_group_name   = aws_db_parameter_group.final_task_parameter_group.name
  skip_final_snapshot    = true
}

resource "aws_security_group" "rds_sg" {
  name   = "task3_rds_sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.private_subnets_cidr
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