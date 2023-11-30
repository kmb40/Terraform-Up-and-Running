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