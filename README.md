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

### Chapter 4
#### Observations 
**State Files** There were multiple tasks related to state files worth noting. 
- Rules for Both (Local and Remote State files)
1. The state file contains the current state of the infrastructure.   
2. The configuration file (main.tf) contains the desired state of the infrastructure.   
3. When ever there is a delta (mismatch information) between the two files, terraform will attempt to resolve the mismatch by destroying or creating infrastructure.     
E.g. If there are two S3 buckets listed in the state file and the config file is updated to show only one bucket, the bucket that is NOT listed will be destroyed upon the use of the tf apply command. This is desired functionality.    

- Rules for Remote (Cloud, S3, etc)    
1. When using a remote hosted state file, there is no local state file needed. It would be a good practice to create the remote location before updating the configuration file to use it.     
2. In the event that Terraform Cloud is being used, this is not required as the remote location can be created automatically once the configuration file is updated to use a remote backend.   
#https://developer.hashicorp.com/terraform/tutorials/state/cloud-migrate#configure-terraform-cloud-integration  
3. The large challenge here is that in the cse of s3. Once the bucket has been created, it must be referenced in the config file and state file OR completely removed for each. Since it is being used to house the state file, it would be a risk to have it destroyed. In the case of TF Cloud, this isnt an issue. 
3a. Another alternative is to manually create the S3 bucket and avoid TF all together. Additionally, Terrgrunt is an application which addresses this issue - https://terragrunt.gruntwork.io/

**Resources**
Article on manipulating (importing, removing, updating) state files -
https://dev.to/aws-builders/how-to-manage-and-manipulate-resources-in-terraform-state-file-2-2hle#:~:text=4.-,Move%20a%20resource%20to%20a%20different%20state%20file,not%20in%20your%20configuration%20file. 

**Issue**
If these observations are not considered, there may be resources that are destroyed by mistake. 

**Solution**
State file and Configuration files must match. 
- When removing the resources from the state file, you presented with an error that they do not exist in the configuration file.
- When removing the resources from the config file, you are basically asking TF to destroy those items.
- Thus to avoid errors while keeping the remote state file in tact, the resources must be removed from both locations.