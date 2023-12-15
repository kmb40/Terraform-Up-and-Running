terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

provider "aws" {
region = "us-east-1"
}

module "users" {
  source = "../"
  count = length(var.user_names)
  user_name = var.user_names[count.index]
}