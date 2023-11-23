provider "aws" {
  region = "us-east-1" // Book example is us-east-2
}

resource "aws_instance" "example" {
  ami               = "ami-06aa3f7caf3a30282" // Using an us-east-1 similar ami  
  instance_type     = "t2.micro"
}

terraform {
backend "s3" {
# Replace this with your bucket name!
bucket = "terraform-up-and-running-state-kmb2"
key = "workspaces-example/terraform.tfstate"
region = "us-east-1"

# Replace this with your DynamoDB table name!
dynamodb_table = "terraform-up-and-running-locks"
encrypt = true
 }
}