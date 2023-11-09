provider "aws" {
region = "us-east-1" // Book example is us-east-2
}

resource "aws_instance" "example" {
  instance_type     = "t2.micro"
//  availability_zone = "us-east-2a"
  ami               = "ami-06aa3f7caf3a30282" // Using an us-east-1 similar ami

//  user_data = <<-EOF
//              #!/bin/bash
//              sudo service apache2 start
//              EOF
}