# This file reflects the "The terraform_remote_state Data Source" section of Chapter 3 - KB

terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
  /*
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "terraform-up-and-running-state-kmb2"
    key = "global/s3/terraform.tfstate"
    region = "us-east-1"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt = true
    }  
   */
}

/* Removing per instructions when creating module.
provider "aws" {
  region = "us-east-1" // Book example is us-east-2
}
*/

resource "aws_launch_configuration" "example" {
  image_id          = "ami-06aa3f7caf3a30282" // Using an us-east-1 similar ami  
  instance_type     = var.instance_type
  security_groups   = [aws_security_group.instance.id]

# Render the User Data script as a template
   user_data = templatefile("${path.module}/user-data.sh", {
   server_port = var.server_port
   db_address = data.terraform_remote_state.db.outputs.address
   db_port = data.terraform_remote_state.db.outputs.port
})

   # Required when using a launch configuration with an auto scaling group.
   lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier  = data.aws_subnets.default.ids

  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

  min_size = var.min_size
  max_size = var.max_size

  tag {
    key                 = "Name"
    value               = var.cluster_name
    propagate_at_launch = true
  }
}

resource "aws_security_group" "instance" {
  name = "${var.cluster_name}-instance"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    tags = {
    Name = "terraform-example-instance-sg"
  }  
}

resource "aws_lb" "example" {
  name               = var.cluster_name
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = local.http_port
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "asg" {
  name = var.cluster_name
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

resource "aws_security_group" "alb" {
  name = "${var.cluster_name}-alb"
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type = "ingress"
  security_group_id = aws_security_group.alb.id

  from_port   = local.http_port
  to_port     = local.http_port
  protocol    = local.tcp_protocol
  cidr_blocks = local.all_ips
}

resource "aws_security_group_rule" "allow_http_outbound" {
  type = "egress"
  security_group_id = aws_security_group.alb.id

  from_port   = local.http_port
  to_port     = local.http_port
  protocol    = local.any_protocol
  cidr_blocks = local.all_ips
}

# Used to point to the remote state file
data "terraform_remote_state" "db" {
   backend = "s3"

   config = {
   bucket = var.db_remote_state_bucket
   #bucket = "terraform-up-and-running-state-kmb2"
   key = var.db_remote_state_key
   #key = "global/s3/terraform.tfstate"
   #key = "stage/data-stores/mysql/terraform.tfstate"
   region = "us-east-1"
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

locals {
http_port = 80
any_port = 0
any_protocol = "-1"
tcp_protocol = "tcp"
all_ips = ["0.0.0.0/0"]
}