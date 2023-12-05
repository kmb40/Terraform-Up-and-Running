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
    key = "stage/services/webserver-cluster/terraform.tfstate"
    encrypt = true
    }  
   
}

provider "aws" {
region = "us-east-1"
}

module "webserver_cluster" {
source = "../../../modules/services/webserver-cluster"

  # (parameters hidden for clarity)

  cluster_name           = "webservers-stage"
  db_remote_state_bucket = "terraform-up-and-running-state-kmb2"
  db_remote_state_key    = "stage/services/webserver-cluster/terraform.tfstate"

  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 2
}

resource "aws_security_group_rule" "allow_testing_inbound" {
  type              = "ingress"
  security_group_id = module.webserver_cluster.alb_security_group_id

  from_port   = 12345
  to_port     = 12345
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}