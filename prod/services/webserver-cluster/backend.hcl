# Partial configuration. The other settings (e.g., bucket,region) will be
# passed in from a file via -backend-config arguments to 'terraform init'
# backend.hcl
bucket = "terraform-up-and-running-state-kmb2"
region = "us-east-1"
dynamodb_table = "terraform-up-and-running-locks"
encrypt = true