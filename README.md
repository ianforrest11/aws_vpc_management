# aws_vpc_management (in progress)
repository for managing AWS VPCs and related resources for portfolio AWS account

# modules included:
- subnet management
- vpc management

# subnet management
- This module creates AWS subnets, specifies them as public or private, and associates them to a VPC
- The subnet naming convention is `SUBNETTYPE_subnet_SUBNETTYPENUMBER`
- For example, to create a second public subnet:
  - Navigate to `subnet_management/terraform/main.tf` and add a module called `public_subnet_2_creation`
  - Set the `source` variable to `git@github.com:ianforrest11/terraform_templates.git//aws/vpc_subnet?ref=main`
  - Define required variables `cidr_block`, `map_public_ip_on_launch`, & `name` like `var.VARIABLENAME`
  - Use `data` Terraform resource to associate `vpc_id` to the default VPC: `data.aws_vpc.default_vpc.id`.  If you'd like to use a different vpc, please specify the variable like the others 
  - Optionally set `availability_zone` like other variables if specifying a specific availability zone. 
  - See the example below:
```
module "public_subnet_2_creation" {
  source                    = "git@github.com:ianforrest11/terraform_templates.git//aws/vpc_subnet?ref=main"
  cidr_block                = var.public_subnet_2_cidr_block
  map_public_ip_on_launch   = var.public_subnet_2_map_public_ip_on_launch
  name                      = var.public_subnet_2_name
  vpc_id                    = data.aws_vpc.default_vpc.id
}
```
- Second, navigate to `subnet_management/variables/terraform.tfvars` and add variables for every `var.` parameter used above.  Determining `cidr_block` is outside the scope of this project. For example:
```
public_subnet_2_cidr_block               = "10.0.3.0/24"
public_subnet_2_map_public_ip_on_launch  = true
public_subnet_2_name                     = "public_subnet_2"
```
  - please note that if you are creating a `private` subnet, the value of `map_public_ip_on_launch` should be `false`
- Third, navigate to the `subnet_management/terraform/variables.tf` file and add placeholder variables to recognize the variables we added in the previous step.  They can be as simple as one line: 
```
variable "public_subnet_2_cidr_block" {}
variable "public_subnet_2_map_public_ip_on_launch" {}
variable "public_subnet_2_name" {}
```
- once this updated configuration is pushed to the `main` branch, the `.github/workflows/terraform.yml` workflow will pick it up and create the subnet `public_subnet_2` in AWS

# VPC management
- This module creates AWS VPCs
- For example, to create a `dev` VPC:
  - Navigate to `subnet_management/terraform/main.tf` and add a module called `dev_vpc_creation`
  - Set the `source` variable to `git@github.com:ianforrest11/terraform_templates.git//aws/vpc_vpc?ref=main`
  - Define required variables `cidr_block`, `instance_tenancy`, & `name` like `var.ENVNAME_vpc_VARIABLENAME`
  - See the example below:
```
module "dev_vpc_creation" {
  source           = "git@github.com:ianforrest11/terraform_templates.git//aws/vpc_vpc?ref=main"
  cidr_block       = var.dev_vpc_cidr_block
  instance_tenancy = var.dev_vpc_instance_tenancy
  name             = var.dev_vpc_name
}
```
- Second, navigate to `vpc_management/variables/terraform.tfvars` and add variables for every `var.` parameter used above.  Determining `cidr_block` is outside the scope of this project. For example:
```
dev_vpc_cidr_block       = "10.1.0.0/16"
dev_vpc_instance_tenancy = "default"
dev_vpc_name             = "dev_vpc"
```
- Third, navigate to the `vpc_management/terraform/variables.tf` file and add placeholder variables to recognize the variables we added in the previous step.  They can be as simple as one line: 
```
variable "dev_vpc_cidr_block" {}
variable "dev_vpc_instance_tenancy" {}
variable "dev_vpc_name" {}
```
- Optional: if you'd like this VPC to be available to associate to subnets, navigate to `subnet_management/terraform/data.tf` and add a terraform `data` resource for the new `dev` VPC as follows:
```
data "aws_vpc" "dev_vpc" {
  filter {
    name   = "tag:Name"
    values = ["dev_vpc"]
  }
}
```
- once this updated configuration is pushed to the `main` branch, the `.github/workflows/terraform.yml` workflow will pick it up and create VPC `dev_vpc` in AWS