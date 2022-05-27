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

resource "aws_vpc" "task4-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "task4-vpc"
  }
}

resource "aws_subnet" "task4-public-subnet" {
  vpc_id                  = aws_vpc.task4-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "task4-subnet-public"
  }
}

resource "aws_subnet" "task4-private-subnet" {
  vpc_id            = aws_vpc.task4-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2c"

  tags = {
    Name = "task4-subnet-private"
  }
}

resource "aws_internet_gateway" "task4-ig" {
  vpc_id = aws_vpc.task4-vpc.id

  tags = {
    Name = "task4-ig"
  }
}

resource "aws_route_table" "task4-rt-public" {
  vpc_id = aws_vpc.task4-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.task4-ig.id
  }

  tags = {
    Name = "task4-ig"
  }
}

resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.task4-public-subnet.id
  route_table_id = aws_route_table.task4-rt-public.id
}

resource "aws_instance" "ec2_instance_kt_public" {
  ami           = var.AMI_ID
  instance_type = var.ec2_instance_type
  key_name      = var.ssh_key_name
  user_data     = file("commands_public_ec2.sh")
  subnet_id     = aws_subnet.task4-public-subnet.id

  tags = {
    Name = "task4-public-ec2"
  }
}

resource "aws_security_group" "public_allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.task4-vpc.id

  ingress {
    description = "Enable SSH access via port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "public_allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.task4-vpc.id

  ingress {
    description = "Allow HTTP to client host"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface_sg_attachment" "sg_public_ssh_attachment" {
  security_group_id    = aws_security_group.public_allow_ssh.id
  network_interface_id = aws_instance.ec2_instance_kt_public.primary_network_interface_id
}

resource "aws_network_interface_sg_attachment" "sg_public_http_attachment" {
  security_group_id    = aws_security_group.public_allow_http.id
  network_interface_id = aws_instance.ec2_instance_kt_public.primary_network_interface_id
}

resource "aws_instance" "ec2_instance_kt_private" {
  ami           = var.AMI_ID
  instance_type = var.ec2_instance_type
  key_name      = var.ssh_key_name
  subnet_id     = aws_subnet.task4-private-subnet.id
  user_data     = file("commands_private_ec2.sh")

  tags = {
    Name = "task4-private-ec2"
  }
}

resource "aws_security_group" "private_allow_ssh" {
  name        = "private_allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.task4-vpc.id

  ingress {
    description = "Enable SSH access via port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.task4-public-subnet.cidr_block]
  }
}

resource "aws_security_group" "private_allow_http" {
  name        = "private_allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.task4-vpc.id

  ingress {
    description = "Allow HTTP to client host"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.task4-public-subnet.cidr_block]
  }
}

resource "aws_security_group" "private_allow_ping" {
  name        = "allow_ping"
  description = "Allow ping inbound traffic"
  vpc_id      = aws_vpc.task4-vpc.id

  ingress {
    description = "Allow ping to client host"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [aws_subnet.task4-public-subnet.cidr_block]
  }
}

resource "aws_network_interface_sg_attachment" "sg_private_http_attachment" {
  security_group_id    = aws_security_group.private_allow_http.id
  network_interface_id = aws_instance.ec2_instance_kt_private.primary_network_interface_id
}

resource "aws_network_interface_sg_attachment" "sg_private_ping_attachment" {
  security_group_id    = aws_security_group.private_allow_ping.id
  network_interface_id = aws_instance.ec2_instance_kt_private.primary_network_interface_id
}

resource "aws_network_interface_sg_attachment" "sg_private_ssh_attachment" {
  security_group_id    = aws_security_group.private_allow_ssh.id
  network_interface_id = aws_instance.ec2_instance_kt_private.primary_network_interface_id
}

resource "aws_instance" "ec2_nat_instance" {
  ami               = var.AMI_NAT_ID
  instance_type     = var.ec2_instance_type
  key_name          = var.ssh_key_name
  subnet_id         = aws_subnet.task4-public-subnet.id
  source_dest_check = false

  tags = {
    Name = "task4-nat-ec2"
  }
}

resource "aws_network_interface_sg_attachment" "sg_nat_ssh_attachment" {
  security_group_id    = aws_security_group.public_allow_ssh.id
  network_interface_id = aws_instance.ec2_nat_instance.primary_network_interface_id
}

resource "aws_network_interface_sg_attachment" "sg_nat_http_attachment" {
  security_group_id    = aws_security_group.public_allow_http.id
  network_interface_id = aws_instance.ec2_nat_instance.primary_network_interface_id
}

resource "aws_default_route_table" "task4-vpc-dt" {
  default_route_table_id = aws_vpc.task4-vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    instance_id = aws_instance.ec2_nat_instance.id
  }

  tags = {
    Name = "dt-vpc-task4"
  }
}

resource "aws_lb_target_group" "task4-lb-tg" {
  name     = "task4-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.task4-vpc.id
  health_check {
      path = "/index.html"
      port = 80
      healthy_threshold = 6
      unhealthy_threshold = 2
      timeout = 2
      interval = 5
      matcher = "200"
    }
}

resource "aws_lb_target_group_attachment" "task4-attach-private" {
  target_group_arn = aws_lb_target_group.task4-lb-tg.arn
  target_id        = aws_instance.ec2_instance_kt_private.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "task4-attach-public" {
  target_group_arn = aws_lb_target_group.task4-lb-tg.arn
  target_id        = aws_instance.ec2_instance_kt_public.id
  port             = 80
}

resource "aws_lb" "task4-lb" {
  name               = "task4-lb-tf"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_allow_http.id, aws_vpc.task4-vpc.default_security_group_id]
  subnets            = [aws_subnet.task4-public-subnet.id, aws_subnet.task4-private-subnet.id]
  internal = false
}

resource "aws_lb_listener" "task4-lb-listener" {
  load_balancer_arn = aws_lb.task4-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.task4-lb-tg.arn
  }
}