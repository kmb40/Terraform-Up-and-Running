provider "aws" {
region = "us-east-1" // Book example is us-east-2
}

resource "aws_instance" "example" {
  ami               = "ami-06aa3f7caf3a30282" // Using an us-east-1 similar ami  
  instance_type     = "t2.micro"

  tags = {
    Name = "terraform-example"
  }  
  #user_data = <<-EOF
  #            #!/bin/bash
  #            echo "Hello, World" > index.html
  #            nohup busybox httpd -f -p 8080 &
  #            EOF
}