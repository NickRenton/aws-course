resource "aws_vpc" "final_task_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "final_vpc"
  }
}

resource "aws_subnet" "final_task_first_public_subnet" {
  vpc_id                  = aws_vpc.final_task_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "final_subnet_public_1"
  }
}

resource "aws_subnet" "final_task_second_public_subnet" {
  vpc_id            = aws_vpc.final_task_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "final_subnet_public_2"
  }
}

resource "aws_subnet" "final_task_first_private_subnet" {
  vpc_id                  = aws_vpc.final_task_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-west-2c"

  tags = {
    Name = "final_subnet_private_1"
  }
}

resource "aws_subnet" "final_task_second_private_subnet" {
  vpc_id            = aws_vpc.final_task_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "final_subnet_private_2"
  }
}



#resource "aws_lb" "load_balancer_final_task" {
#  name               = "finaltask"
#  load_balancer_type = "application"
#  security_groups    = [var.http_sg_id]
#  subnets            = [aws_subnet.final_task_first_public_subnet.id, aws_subnet.final_task_second_public_subnet.id]
#  internal = false
#}
#
#resource "aws_lb_listener" "lb-listener" {
#  load_balancer_arn = aws_lb.load_balancer_final_task.arn
#  port              = 80
#  protocol          = "HTTP"
#
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.lb_target_group.arn
#  }
#}