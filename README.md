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
Nothing to add.

### Chapter 2
#### Observations 
- `terraform{}`, `required_version`, and `required_providers` entries are not mentioned in the book but are provided in the GitHub examples code. These are not required according to testing. Need to determine purpose.
    - The `version` attribute in `required_providers` is optional but useful when the desired outcome is to prevent untested versions of tf from being used. 
    - `required_version` is optional but useful when the desired outcome is to prevent untested versions of tf from being used. 
    - Research - https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build#terraform-block

**Issue** 
`Deploy one web server` lab failed to allow traffic after the instance was created first and the security group second.
**Resolution** 
Destroyed original instance and deployed new code with the instance and the security group together. 
**Note:** Be sure not to use `https` and to include the port at the end of the url e.g. `http://ec2-54-221-56-68.compute-1.amazonaws.com:8080`

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

### Chapter 3
#### Observations 
- When reading the PDF, there are often times when the chapter is needed but not known which requires scrolling to find the chapter.
**Solution** Place chapter in footer of book.

**Issue**
On `Terraform init,` recieved the following error when setting up module
> Error: Backend configuration changed
>
> A change in the backend configuration has been detected, which may require migrating existing state.
>
> If you wish to attempt automatic migration of the state, use “terraform init -migrate-state”.
> If you wish to store the current configuration with no changes to the state, use “terraform init -reconfigure”.

**Solution**
Attempted to use `terraform init -reconfigure`
> Error: Backend initialization required, please run "terraform init"
> 
> Reason: Unsetting the previously set backend "s3"
> 
> The "backend" is the interface that Terraform uses to store state,
> perform operations, etc. If this message is showing up, it means that the
> Terraform configuration you're using is using a custom configuration for
> the Terraform backend.
> 
> Changes to backend configurations require reinitialization. This allows
> Terraform to set up the new configuration, copy existing state, etc. Please run
> "terraform init" with either the "-reconfigure" or "-migrate-state" flags to
> use the current configuration.
> 
> If the change reason above is incorrect, please verify your configuration
> hasn't changed and try again. At this point, no changes to your existing
> configuration or state have been made.

Used `terraform init -migrate-state` instead.
https://discuss.hashicorp.com/t/confusing-error-message-when-terraform-backend-is-changed/32637