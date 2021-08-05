# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.


terraform {
  source = "github.com/cloudposse//terraform-null-label?ref=0.24.0"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
}
