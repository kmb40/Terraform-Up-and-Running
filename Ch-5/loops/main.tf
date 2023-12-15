/*
provider "aws" {
region = "us-east-1"
}*/

# Uncomment each section (one only at a time) and run `terraform plan` to test each.
/* Single User - KMB
resource "aws_iam_user" "example" {
name = "neo"
}
*/

/* 
resource "aws_iam_user" "example" {
count = 3
name = "neo"
}
*/

/*
resource "aws_iam_user" "example" {
count = 3
name = "neo.${count.index}"
}
*/

resource "aws_iam_user" "example" {
name = var.user_name
}