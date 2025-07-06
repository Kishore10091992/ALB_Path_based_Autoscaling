output "vpc_id" {
 description = "vpc id"
 value = aws_vpc.alb_auto_vpc.id
}

output "sub-1_id" {
 description = "subnet 1 id"
 value = aws_subnet.alb_auto_sub-1.id
}

output "sub-2_id" {
 description = "subnet 2 id"
 value = aws_subnet.alb_auto_sub-2.id
}

output "IGW_id" {
 description = "internet gateway id"
 value = aws_internet_gateway.alb_auto_IGW.id
}

output "route_table_id" {
 description = "route tableid"
 value = aws_route_table.alb_auto_rt.id
}

output "sg_id" {
 description = "security_group_id"
 value = aws_security_group.alb_auto_sg.id
}

output "ami_id" {
 description = "ami_id"
 value = data.aws_ami.amz_lnx.id
}

output "app-1_launch_template_id" {
 description = "app 1 launch template id"
 value = aws_launch_template.app-1_lt.id
}

output "app-2_launch_template_id" {
 description = "app 2 launch template id"
 value = aws_launch_template.app-2_lt.id
}

output "app-1_launch_template_arn" {
 description = "app 1 launch template arn"
 value = aws_launch_template.app-1_lt.arn
}

output "app-2_launch_template_arn" {
 description = "app 2 launch template arn"
 value = aws_launch_template.app-2_lt.arn
}

output "alb_arn" {
 description = "lb arn"
 value = aws_lb.alb_auto.arn
}

output "alb_dns_name" {
 description = "lb dns_name"
 value = aws_lb.alb_auto.dns_name
}

output "app-1_tg_arn" {
 description = "app 1 target group arn"
 value = aws_lb_target_group.tg_app-1.arn
}

output "app-2_tg_arn" {
 description = "app 2 target group arn"
 value = aws_lb_target_group.tg_app-2.arn
}

output "listener_arn" {
 description = "lb listener arn"
 value = aws_lb_listener.alb_auto_listener.arn
}

output "app-1_listener_rule_arn" {
 description = "app 1 listener rule arn"
 value = aws_lb_listener_rule.app-1_listener_rule.arn
}

output "app-2_listener_rule_arn" {
 description = "app 2 listener rule arn"
 value = aws_lb_listener_rule.app-2_listener_rule.arn
}

output "app-1_asg_arn" {
 description = "app 1 asg arn"
 value = aws_autoscaling_group.app-1_asg.arn
}

output "app-2_asg_arn" {
 description = "app 2 asg arn"
 value = aws_autoscaling_group.app-2_asg.arn
}

output "scale_out_app-1_autoscaling_policy_arn" {
 description = "scale_out_app-1_autoscaling_policy_arn"
 value = aws_autoscaling_policy.scale_out_app-1.arn
}

output "scale_in_app-1_autoscaling_policy_arn" {
 description = "scale_in_app-1_autoscaling_policy_arn"
 value = aws_autoscaling_policy.scale_in_app-1.arn
}

output "scale_out_app-2_autoscaling_policy_arn" {
 description = "scale_out_app-2_autoscaling_policy_arn"
 value = aws_autoscaling_policy.scale_out_app-2.arn
}

output "scale_in_app-2_autoscaling_policy_arn" {
 description = "scale_in_app-2_autoscaling_policy_arn"
 value = aws_autoscaling_policy.scale_in_app-2.arn
}

output "high_cpu_app-1_cloudwatch_metric_alarm_arn" {
 description = "high_cpu_app-1_cloudwatch_metric_alarm_arn"
 value = aws_cloudwatch_metric_alarm.high_cpu_app-1.arn
}

output "low_cpu_app-1_cloudwatch_metric_alarm_arn" {
 description = "low_cpu_app-1_cloudwatch_metric_alarm_arn"
 value = aws_cloudwatch_metric_alarm.low_cpu_app-1.arn
}

output "high_cpu_app-2_cloudwatch_metric_alarm_arn" {
 description = "high_cpu_app-2_cloudwatch_metric_alarm_arn"
 value = aws_cloudwatch_metric_alarm.high_cpu_app-2.arn
}

output "low_cpu_app-2_cloudwatch_metric_alarm_arn" {
 description = "low_cpu_app-2_cloudwatch_metric_alarm_arn"
 value = aws_cloudwatch_metric_alarm.low_cpu_app-2.arn
}