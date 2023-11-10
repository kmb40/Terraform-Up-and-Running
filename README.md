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

**Issue** 
`Deploy one web server` lab failed to allow traffic after the instance was created first and the security group second.
**Resolution** 
Destroyed original instance and deployed new code with the instance and the security group together. 

**Issue** 
`Deploy one web server` when using `terraform output` failed to produce results AFTER `output` syntax has been added.
**Resolution** 
`terraform refresh` made it avaialble and returned the desired result. 