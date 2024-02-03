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

resource "aws_iam_user" "example" {
  for_each = toset(var.user_names)
  name     = each.value
}