Implement backend.hcl - complete
Refactor module directory - complete
Refactor stage Root directory - complete
Refactor prod Root directory - complete
Create RDS db for prod Root directory - complete
Test - Plans work for both prod and staging

Finished reading the end of chap 4. versioning and conclusion

Educate Materials
quikStart guide to State Files
# Ref - https://dev.to/aws-builders/how-to-manage-and-manipulate-resources-in-terraform-state-file-2-2hle#:~:text=4.-,Move%20a%20resource%20to%20a%20different%20state%20file,not%20in%20your%20configuration%20file.
 
- Manipulating State Files
-- Show human readable state file `terraform show`
-- Show resources in state file `terraform state list`
-- Remove resource from State File (not destroy) `terraform state rm`
-- Import resouce that exist in AWS account but not in State File `terraform import`
-- Refresh state file when it does not match infrastructure with `terraform refresh`
   Note: This does not update the config file. This may need to be done manually.