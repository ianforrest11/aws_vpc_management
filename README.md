# aws_vpc_management (in progress)
repository for managing AWS VPCs and related resources for portfolio AWS account

# modules included (so far):
- igw management
- subnet management
- vpc management

# subnet management
- This module creates AWS subnets, which are segmented portions of an AWS VPC's IP address range where you can place groups of isolated resources. Subnets allow you to organize your AWS resources within a VPC and provide a layer of network security. Each subnet resides in one Availability Zone (AZ) and can have different configurations, such as public or private accessibility. Public subnets have routes to an Internet Gateway for internet access, while private subnets use NAT gateways or NAT instances for outbound internet access. Subnets play a crucial role in defining the network architecture of your AWS infrastructure, enabling you to deploy and manage applications securely and efficiently within the AWS cloud.
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
- This module creates an AWS VPC, which is a logically isolated virtual network that you define within the AWS cloud. It allows you to launch AWS resources, such as EC2 instances and RDS databases, into a virtual network that you define. A VPC provides several benefits, including control over your virtual networking environment, customizable IP address ranges, and configuration of route tables and network gateways. With AWS VPC, you can create subnets, configure security groups and network ACLs, and establish VPN connections to extend your corporate network into the cloud securely.
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
- Optional: if you'd like this VPC to be available to associate to other resources, navigate to the resource subdirectory's `data.tf` file `subnet_management/terraform/data.tf` and add a terraform `data` resource for the new VPC
```
data "aws_vpc" "dev_vpc" {
  filter {
    name   = "tag:Name"
    values = ["dev_vpc"]
  }
}
```
- once this updated configuration is pushed to the `main` branch, the `.github/workflows/terraform.yml` workflow will pick it up and create VPC `dev_vpc` in AWS

# igw management
- This module creates and internet gateway, which is a horizontally scaled, redundant, and highly available VPC component that facilitates communication between instances in your VPC and the internet. It allows instances in your VPC to initiate outbound connections to the internet and enables incoming traffic from the internet to reach instances with public IP addresses. The Internet Gateway ensures that instances in the VPC can interact with the internet while maintaining network isolation. It performs network address translation (NAT) for instances with public IP addresses, allowing them to communicate with the internet while preserving the private IP addresses within the VPC.
- For example, to create a `dev` internet gateway using the `default` VPC:
  - Navigate to `igw_management/terraform/main.tf` and add a module called `dev_vpc_igw`
  - Set the `source` variable to `git@github.com:ianforrest11/terraform_templates.git//aws/vpc_igw?ref=main`
  - Define required variable `name` as `var.dev_vpc_igw_name`
  - Use `data` Terraform resource to associate `vpc_id` to the dev VPC `data.aws_vpc.dev_vpc.id`, assuming it is created.  If you'd like to use a different vpc, please specify the variable like the others
- Second, navigate to `igw_management/variables/terraform.tfvars` and add a variable for `name` like so: `dev_vpc_igw_name = "dev_vpc_igw"`
- Third, navigate to the `igw_management/terraform/variables.tf` file and add placeholder variables to recognize the variables we added in the previous step.  They can be as simple as one line: `variable "dev_vpc_igw_name" {}`
- once this updated configuration is pushed to the `main` branch, the `.github/workflows/terraform.yml` workflow will pick it up and create igw `dev_vpc_igw` in AWS