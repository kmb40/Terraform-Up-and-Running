# terraform
Terraform Continuing Education with Projects

**Objective:** Review [Terraform Up and Running](https://www.terraformupandrunning.com/) for Research and Development.

### Tools used
* VSCode 
* Gitpod
* MacBook Ventura

### Installation
* Followed installation instructions for "Mac" at https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli.
* Enabled Tab Completion for Terraform using `touch ~/.bashrc`.
* Installed the autocomplete package using `terraform -install-autocomplete`.

### Chapter 1

### Chapter 2
#### Obeservations 
- `terraform{}`, `required_version`, `required_providers` entries are not mentioned in the book but are provided in the GitHub examples code. These are not required according to testing. Need to determine purpose.
    - The `version` attribute in `required_providers` is optional but useful when the desired outcome is to prevent untested versions of tf from being used. 
    - `required_version` is optional but useful when the desired outcome is to prevent untested versions of tf from being used. 
    - Research - https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build#terraform-block

**Issue** 
`Deploy one web server` lab failed to allow traffic after the instance was created first and the security group second.
**Resolution** 
Destroyed original instance and deployed new code with the instance and the security group together. 

**Issue** 
`Deploy one web server` when using `terraform output` failed to produce results AFTER `output` syntax has been added.
**Resolution** 
`terraform refresh` made displayed the result. Also, running `terraform apply` no plan produces the desired outcome. 

**Issue** 
`Deploying a Cluster of Web Servers` when using `terraform apply` failed to complete apply at aws_autoscaling_group step and produced the following:

```
Error: waiting for Auto Scaling Group (terraform-20231111102145165600000002) capacity satisfied: scaling activity (da862ef7-9b96-13a2-a575-955714ae9369): Failed: Access denied when attempting to assume role arn:aws:iam::734732107779:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling. Validating load balancer configuration failed.
│ scaling activity (40262ef7-9b93-3e2d-2dfa-96a841754cd2): Failed: Access denied when attempting to assume role arn:aws:iam::734732107779:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling. Validating load balancer configuration failed.
│ 
│   with aws_autoscaling_group.example,
│   on main.tf line 58, in resource "aws_autoscaling_group" "example":
│   58: resource "aws_autoscaling_group" "example" {
│ 
╵
```

**Resolution** 
Reran `terraform plan` and received `# aws_autoscaling_group.example is tainted, so must be replaced` which resolved the issue.