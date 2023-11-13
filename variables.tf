# Variables
#variable "server_port" {
#  description = "The port the server will use for HTTP requests"
#  type = number
#  default = 8080
#}
#
#variable "security_group_name" {
#  description = "The name of the security group"
#  type        = string
#  default     = "terraform-example-instance"
#}
#
#variable "alb_name" {
#  description = "The application load balancer name"
#  type        = string
#  default     = "terraform-alb-example-instance"
#}
#
#variable "alb_security_group_name" {
#  description = "The name of the application load balancer security group"
#  type        = string
#  default     = "terraform-alb-sg-example-instance"
#}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "terraform-up-and-running-state-kmb2"
}