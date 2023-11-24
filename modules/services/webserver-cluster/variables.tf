# Variables
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

variable "alb_name" {
  description = "The application load balancer name"
  type        = string
  default     = "terraform-alb-example-instance"
}

variable "alb_security_group_name" {
  description = "The name of the application load balancer security group"
  type        = string
  default     = "terraform-alb-sg-example-instance"
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "terraform-up-and-running-state-kmb2"
}

variable "cluster_name" {
description = "The name to use for all the cluster resources"
type = string
}

variable "db_remote_state_bucket" {
description = "The name of the S3 bucket for the database's
remote state"
type = string
}

variable "db_remote_state_key" {
description = "The path for the database's remote state in S3"
type = string
}