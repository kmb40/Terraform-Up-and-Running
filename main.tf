provider "aws" {
  region = "us-east-1" // Book example is us-east-2
}

resource "aws_instance" "example" {
  ami               = "ami-06aa3f7caf3a30282" // Using an us-east-1 similar ami  
  instance_type     = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF
            
  user_data_replace_on_change = true

  tags = {
    Name = "terraform-example"
  }  
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type = number
  default = 8080
}

variable "security_group_name" {
  description = "The name of the security group"
  type        = string
  default     = "terraform-example-instance"
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

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

# Dsiplays at the end of tf plan/apply as "Outputs:". Doesnt trigger infra changes on tf plan/apply.
output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP of the Instance"
}