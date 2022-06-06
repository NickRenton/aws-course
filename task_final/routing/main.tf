resource "aws_internet_gateway" "final_task_ig" {
  vpc_id = var.vpc_id

  tags = {
    Name = "final_task_ig"
  }
}

resource "aws_route_table" "final_rt_public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.final_task_ig.id
  }

  tags = {
    Name = "rt_public_final"
  }
}

resource "aws_route_table" "final_rt_private" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    instance_id = var.nat_instance_id
  }

  tags = {
    Name = "rt_private_final"
  }
}

resource "aws_route_table_association" "f_public_association" {
  subnet_id      = var.first_public_subnet_id
  route_table_id = aws_route_table.final_rt_public.id
}

resource "aws_route_table_association" "s_public_association" {
  subnet_id      = var.second_public_subnet_id
  route_table_id = aws_route_table.final_rt_public.id
}

resource "aws_route_table_association" "f_private_association" {
  subnet_id      = var.first_private_subnet_id
  route_table_id = aws_route_table.final_rt_private.id
}

resource "aws_route_table_association" "s_private_association" {
  subnet_id      = var.second_private_subnet_id
  route_table_id = aws_route_table.final_rt_private.id
}

resource "aws_vpc_endpoint" "dynamodb_vpc_endpoint" {
  vpc_id          = var.vpc_id
  service_name    = "com.amazonaws.us-west-2.dynamodb"
  route_table_ids = [aws_route_table.final_rt_private.id, aws_route_table.final_rt_public.id]
}

resource "aws_lb_target_group" "final_task_tg" {
  name     = "finaltasktg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
      path = "/health"
      port = 80
      healthy_threshold = 6
      unhealthy_threshold = 2
      timeout = 2
      interval = 5
      matcher = "200-499"
    }
}

resource "aws_lb" "final_task_lb" {
  name               = "finaltasklbtf"
  load_balancer_type = "application"
  security_groups    = [var.http_sg_id]
  subnets            = [var.first_public_subnet_id, var.second_public_subnet_id]
  internal = false
}

resource "aws_lb_listener" "final_task_listener" {
  load_balancer_arn = aws_lb.final_task_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.final_task_tg.arn
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = var.asg_id
  alb_target_group_arn    = aws_lb_target_group.final_task_tg.arn
}