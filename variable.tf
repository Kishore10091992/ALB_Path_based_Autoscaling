variable "default_ip" {
 description = "default i[p address"
 type = string
 default = "0.0.0.0/0"
}

variable "environmet" {
 description = "environment name"
 type = string
 default = "learn_env"
}

variable "aws_region" {
 description = "aws region"
 type = string
 default = "us-east-1"
}

variable "az-1" {
 description = "availability zone 1"
 type = string
 default = "us-east-1a"
}

variable "az-2" {
 description = "availability zone 2"
 type = string
 default = "us-east-1c"
}

variable "vpc_cidr" {
 description = "cidr for vpc"
 type = string
 default = "172.168.0.0/16"
}

variable "subnet-1_cidr" {
 description = "cidr for subnet 1"
 type = string
 default = "172.168.0.0/24"
}

variable "subnet-2_cidr" {
 description = "cidr for subnet 2"
 type = string
 default = "172.168.1.0/24"
}

variable "lb_type" {
 description = "load balancer type"
 type = string
 default = "application"
}

variable "sg_protocol" {
 description = "security group protocol"
 type = string
 default = "-1"
}

variable "data_ami_mostrecent" {
 description = "ami most recent value"
 type = bool
 default = "true"
}

variable "instance_type" {
 description = "ec2 instance type"
 type = string
 default = "t2.micro"
}

variable "asg-desired_capacity" {
 description = "desired capacity for asg"
 type = number
 default = 2
}

variable "asg-max_size" {
 description = "max size for asg"
 type = number
 default = 3
}

variable "asg-min_size" {
 description = "min size for asg"
 type = number
 default = 1
}