terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }

  backend "s3" {
    # Replace this with your bucket name!
    bucket = "terraform-up-and-running-state-kmb2"
    key = "prod/data-stores/mysql/terraform.tfstate"
    region = "us-east-1"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt = true
    }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "prod_example" {
  identifier_prefix = "terraform-up-and-running"
  engine = "mysql"
  allocated_storage = 10
  instance_class = "db.t2.micro"
  skip_final_snapshot = true
  db_name = "example_prod_database"

# How should we set the username and password?
  username = var.db_username
  password = var.db_password
}