resource "aws_instance" "ec2_nat_instance" {
  ami               = var.ami_nat_id
  instance_type     = var.ec2_instance_type
  key_name          = var.ssh_key_name
  subnet_id         = var.first_public_subnet_id
  source_dest_check = false

  tags = {
    Name = "final_nat_ec2"
  }
}

resource "aws_instance" "ec2_private_instance" {
  ami                  = var.ami_id
  instance_type        = var.ec2_instance_type
  key_name             = var.ssh_key_name
  subnet_id            = var.first_private_subnet_id
  iam_instance_profile = var.instance_profile_id
  user_data            = <<-EOF
    #! /bin/bash
    sudo su
    export RDS_HOST=${var.rds_hostname}
    yum update -y
    yum install java-1.8.0-openjdk -y

    aws s3 cp s3://${var.s3_bucket_name}/persist3-2021-0.0.1-SNAPSHOT.jar /home/

    amazon-linux-extras install postgresql10 -y
    java -jar /home/persist3-2021-0.0.1-SNAPSHOT.jar
  EOF


  tags = {
    Name = "final_private_ec2"
  }
}

resource "aws_security_group" "public_allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP to client host"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "public_allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Enable SSH access via port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "public_allow_https" {
  name        = "allow_https"
  description = "Allow HTTPS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTPS to client host"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "private_allow_ssh" {
  name        = "private_allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Enable SSH access via port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.first_public_cidr, var.second_public_cidr]
  }
}

resource "aws_security_group" "private_allow_ping" {
  name        = "allow_ping"
  description = "Allow ping inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow ping to client host"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.first_public_cidr, var.second_public_cidr]
  }
}

resource "aws_network_interface_sg_attachment" "sg_private_ssh_attachment" {
  security_group_id    = aws_security_group.private_allow_ssh.id
  network_interface_id = aws_instance.ec2_private_instance.primary_network_interface_id
}

resource "aws_network_interface_sg_attachment" "sg_private_ping_attachment" {
  security_group_id    = aws_security_group.private_allow_ping.id
  network_interface_id = aws_instance.ec2_private_instance.primary_network_interface_id
}

resource "aws_network_interface_sg_attachment" "sg_nat_ssh_attachment" {
  security_group_id    = aws_security_group.public_allow_ssh.id
  network_interface_id = aws_instance.ec2_nat_instance.primary_network_interface_id
}

resource "aws_network_interface_sg_attachment" "sg_nat_http_attachment" {
  security_group_id    = aws_security_group.public_allow_http.id
  network_interface_id = aws_instance.ec2_nat_instance.primary_network_interface_id
}

resource "aws_network_interface_sg_attachment" "sg_nat_https_attachment" {
  security_group_id    = aws_security_group.public_allow_https.id
  network_interface_id = aws_instance.ec2_nat_instance.primary_network_interface_id
}

resource "aws_launch_template" "public_ec2_template" {
  name_prefix            = "public_ec2"
  image_id               = var.ami_id
  instance_type          = var.ec2_instance_type
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [
    aws_security_group.public_allow_https.id,
    aws_security_group.public_allow_http.id,
    aws_security_group.public_allow_ssh.id
  ]
  user_data = filebase64("ec_2/install.sh")

  iam_instance_profile {
    arn = var.instance_profile_arn
  }
}

resource "aws_autoscaling_group" "final_task_asg" {
  desired_capacity    = 2
  max_size            = 2
  min_size            = 2
  vpc_zone_identifier = [var.first_public_subnet_id, var.second_public_subnet_id]

  launch_template {
    id = aws_launch_template.public_ec2_template.id
  }
}
