terraform {
 cloud {
   organization = "1st_Terraform_Cloud"
   
   workspaces {
    name = "ALB_Path_based_Autoscaling"
   }
 }
}

provider "aws" {
 region = var.aws_region
}

locals {
 project_name = "ALB_Path_based_Autoscaling"
 full_name = "${local.project_name}-var.environment"
}

resource "aws_vpc" "alb_auto_vpc" {
 cidr_block = var.vpc_cidr
 
 tags = {
  Name = "${local.full_name}-alb_auto_vpc"
 }
}

resource "aws_subnet" "alb_auto_sub-1" {
 vpc_id = aws_vpc.alb_auto_vpc.id
 cidr_block = var.subnet-1_cidr
 availability_zone = var.az-1
 
 tags = {
  Name = "${local.full_name}-alb_auto_sub-1"
 }
}

resource "aws_subnet" "alb_auto_sub-2" {
 vpc_id = aws_vpc.alb_auto_vpc.id
 cidr_block = var.subnet-2_cidr
 availability_zone = var.az-2
 
 tags = {
  Name = "${local.full_name}-alb_auto_sub-2"
 }
}

resource "aws_internet_gateway" "alb_auto_IGW" {
 vpc_id = aws_vpc.alb_auto_vpc.id
 
 tags = {
  Name = "${local.full_name}-alb_auto_IGW"
 }
}

resource "aws_route_table" "alb_auto_rt" {
 vpc_id = aws_vpc.alb_auto_vpc.id
 
 route {
  cidr_block = var.default_ip
  gateway_id = aws_internet_gateway.alb_auto_IGW.id
 }
 
 tags = {
  Name = "${local.full_name}-alb_auto_rt"
 }
}

resource "aws_route_table_association" "sub-1_rt_ass" {
 route_table_id = aws_route_table.alb_auto_rt.id
 subnet_id = aws_subnet.alb_auto_sub-1.id
}

resource "aws_route_table_association" "sub-2_rt_ass" {
 route_table_id = aws_route_table.alb_auto_rt.id
 subnet_id = aws_subnet.alb_auto_sub-2.id
}

resource "aws_security_group" "alb_auto_sg" {
 vpc_id = aws_vpc.alb_auto_vpc.id
 
 ingress {
  from_port = 0
  to_port = 0
  protocol = var.sg_protocol
  cidr_blocks = [var.default_ip]
 }
 
 egress {
  from_port = 0
  to_port = 0
  protocol = var.sg_protocol
  cidr_blocks = [var.default_ip]
 }
 
 tags = {
  Name = "${local.full_name}-alb_auto_sg"
 }
}

data "aws_ami" "amz_lnx" {
 most_recent = var.data_ami_mostrecent
 owners = ["amazon"]
 
 filter {
  name = "name"
  values = ["amzn2-ami-hvm-*"]
 }
}

resource "aws_launch_template" "app-1_lt" {
 image_id = data.aws_ami.amz_lnx.id
 instance_type = var.instance_type
 
 network_interfaces {
  associate_public_ip_address = true
  security_groups = [aws_security_group.alb_auto_sg.id]
 }

 user_data = base64encode(<<-EOF
  #!/bin/bash
  yum update -y
  amazon-linux-extras install nginx1 -y
  systemctl enable nginx
  systemctl start nginx

  # Create directory and HTML content
  mkdir -p /usr/share/nginx/html/app1
  echo "<h1>This is from APP-1</h1>" > /usr/share/nginx/html/app1/index.html

  # Configure nginx to serve /app1
  cat <<EOC > /etc/nginx/conf.d/app1.conf
  server {
      listen 80;
      location /app1/ {
          root /usr/share/nginx/html;
          index index.html;
      }
  }
  EOC

  systemctl restart nginx
  EOF
 )

 tags = {
  Name = "${local.full_name}-alb_auto_lt-1"
 }
}

resource "aws_launch_template" "app-2_lt" {
 image_id = data.aws_ami.amz_lnx.id
 instance_type = var.instance_type
 
 network_interfaces {
  associate_public_ip_address = true
  security_groups = [aws_security_group.alb_auto_sg.id]
 }
 
 user_data = base64encode(<<-EOF
  #!/bin/bash
  yum update -y
  amazon-linux-extras install nginx1 -y
  systemctl enable nginx
  systemctl start nginx

  mkdir -p /usr/share/nginx/html/app2
  echo "<h1>This is from APP-2</h1>" > /usr/share/nginx/html/app2/index.html

  cat <<EOC > /etc/nginx/conf.d/app2.conf
  server {
      listen 80;
      location /app2 {
          alias /usr/share/nginx/html/app2;
          index index.html;
      }
  }
  EOC

  systemctl restart nginx
 EOF
 )

 tags = {
  Name = "${local.full_name}-alb_auto_lt-2"
 }
}

resource "aws_lb" "alb_auto" {
 load_balancer_type = var.lb_type
 security_groups = [aws_security_group.alb_auto_sg.id]
 subnets = [aws_subnet.alb_auto_sub-1.id, aws_subnet.alb_auto_sub-2.id]
 
 tags = {
  Name = "${local.full_name}-alb_auto"
 }
}

resource "aws_lb_target_group" "tg_app-1" {
 port = 80
 protocol = "HTTP"
 vpc_id = aws_vpc.alb_auto_vpc.id
 target_type = "instance"

 health_check {
  path = "/app1"
  protocol = "HTTP"
  matcher = "200"
  interval = 30
  timeout = 5
  healthy_threshold = 2
  unhealthy_threshold = 2
 }
 
 tags = {
  Name = "${local.full_name}-tg_app-1"
 }
}

resource "aws_lb_target_group" "tg_app-2" {
 port = 80
 protocol = "HTTP"
 vpc_id = aws_vpc.alb_auto_vpc.id
 target_type = "instance"

  health_check {
  path = "/app2"
  protocol = "HTTP"
  matcher = "200"
  interval = 30
  timeout = 5
  healthy_threshold = 2
  unhealthy_threshold = 2
 }
 
 tags = {
  Name = "${local.full_name}-tg_app-2"
 }
}

resource "aws_lb_listener" "alb_auto_listener" {
 port = 80
 protocol = "HTTP"
 load_balancer_arn = aws_lb.alb_auto.arn
 default_action {
  type = "fixed-response"
  fixed_response {
   content_type = "text/plain"
   message_body = "page notfound"
   status_code = "404"
  }
 }
}

resource "aws_lb_listener_rule" "app-1_listener_rule" {
 listener_arn = aws_lb_listener.alb_auto_listener.arn
 priority = 100
 
 action {
  type = "forward"
  target_group_arn = aws_lb_target_group.tg_app-1.arn
 }
 
 condition {
  path_pattern {
   values = ["/app1"]
  }
 }
}

resource "aws_lb_listener_rule" "app-2_listener_rule" {
 listener_arn = aws_lb_listener.alb_auto_listener.arn
 priority = 200
 
 action {
  type = "forward"
  target_group_arn = aws_lb_target_group.tg_app-2.arn
 }
 
 condition {
  path_pattern {
   values = ["/app2"]
  }
 }
}

resource "aws_autoscaling_group" "app-1_asg" {
 desired_capacity = var.asg-desired_capacity
 max_size = var.asg-max_size
 min_size = var.asg-min_size
 vpc_zone_identifier = [aws_subnet.alb_auto_sub-1.id, aws_subnet.alb_auto_sub-2.id]
 target_group_arns = [aws_lb_target_group.tg_app-1.arn]
 launch_template {
  id = aws_launch_template.app-1_lt.id
  version = "$Latest"
 }
}

resource "aws_autoscaling_group" "app-2_asg" {
 desired_capacity = var.asg-desired_capacity
 max_size = var.asg-max_size
 min_size = var.asg-min_size
 vpc_zone_identifier = [aws_subnet.alb_auto_sub-1.id, aws_subnet.alb_auto_sub-2.id]
 target_group_arns = [aws_lb_target_group.tg_app-2.arn]
 launch_template {
  id = aws_launch_template.app-2_lt.id
  version = "$Latest"
 }
}

resource "aws_autoscaling_policy" "scale_out_app-1" {
 name = "scale_out_app-1"
 autoscaling_group_name = aws_autoscaling_group.app-1_asg.name
 adjustment_type = "ChangeInCapacity"
 scaling_adjustment = 1
 cooldown = 300
}

resource "aws_autoscaling_policy" "scale_in_app-1" {
 name = "scale_in_app-1"
 autoscaling_group_name = aws_autoscaling_group.app-1_asg.name
 adjustment_type = "ChangeInCapacity"
 scaling_adjustment = -1
 cooldown = 300
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_app-1" {
 alarm_name = "high_cpu_app-1"
 comparison_operator = "GreaterThanThreshold"
 evaluation_periods = 2
 metric_name = "CPUUtilization"
 namespace = "AWS/EC2"
 period = 120
 statistic = "Average"
 threshold = 75
 
 dimensions = {
  AutoScalingGroupName = aws_autoscaling_group.app-1_asg.name
 }
 
 alarm_actions = [aws_autoscaling_policy.scale_out_app-1.arn]
}

resource "aws_cloudwatch_metric_alarm" "low_cpu_app-1" {
 alarm_name = "low_cpu_app-1"
 comparison_operator = "LessThanThreshold"
 evaluation_periods = 2
 metric_name = "CPUUtilization"
 namespace = "AWS/EC2"
 period = 120
 statistic = "Average"
 threshold = 30
 
 dimensions = {
  AutoScalingGroupName = aws_autoscaling_group.app-1_asg.name
 }
 
 alarm_actions = [aws_autoscaling_policy.scale_in_app-1.arn]
}

resource "aws_autoscaling_policy" "scale_out_app-2" {
 name = "scale_out_app-2"
 autoscaling_group_name = aws_autoscaling_group.app-2_asg.name
 adjustment_type = "ChangeInCapacity"
 scaling_adjustment = 1
 cooldown = 300
}

resource "aws_autoscaling_policy" "scale_in_app-2" {
 name = "scale_in_app-2"
 autoscaling_group_name = aws_autoscaling_group.app-2_asg.name
 adjustment_type = "ChangeInCapacity"
 scaling_adjustment = -1
 cooldown = 300
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_app-2" {
 alarm_name = "high_cpu_app-2"
 comparison_operator = "GreaterThanThreshold"
 evaluation_periods = 2
 metric_name = "CPUUtilization"
 namespace = "AWS/EC2"
 period = 120
 statistic = "Average"
 threshold = 75
 
 dimensions = {
  AutoScalingGroupName = aws_autoscaling_group.app-2_asg.name
 }
 
 alarm_actions = [aws_autoscaling_policy.scale_out_app-2.arn]
}

resource "aws_cloudwatch_metric_alarm" "low_cpu_app-2" {
 alarm_name = "low_cpu_app-2"
 comparison_operator = "LessThanThreshold"
 evaluation_periods = 2
 metric_name = "CPUUtilization"
 namespace = "AWS/EC2"
 period = 120
 statistic = "Average"
 threshold = 30
 
 dimensions = {
  AutoScalingGroupName = aws_autoscaling_group.app-2_asg.name
 }
 
 alarm_actions = [aws_autoscaling_policy.scale_in_app-2.arn]
}