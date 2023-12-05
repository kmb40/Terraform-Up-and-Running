terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
  
  backend "s3" {
   # Partial configuration. The other settings (e.g., bucket,region) will be
   # passed in from a file via -backend-config arguments to 'terraform init'
    key = "prod/services/webserver-cluster/terraform.tfstate"
    encrypt = true
    }  
   
}

provider "aws" {
region = "us-east-1"
}

module "webserver_cluster" {
source = "../../../modules/services/webserver-cluster"

  # (parameters hidden for clarity)

  cluster_name           = "webservers-prod"
  db_remote_state_bucket = "terraform-up-and-running-state-kmb2"
  db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"

  instance_type = "m4.large"
  min_size      = 2
  max_size      = 10
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name = "scale-out-during-business-hours"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 10
  recurrence            = "0 9 * * *"

  autoscaling_group_name = module.webserver_cluster.asg_name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name = "scale-in-at-night"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 2
  recurrence            = "0 17 * * *"

  autoscaling_group_name = module.webserver_cluster.asg_name
}