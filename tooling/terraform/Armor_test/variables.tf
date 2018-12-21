
# ------------------------------------------
# Credentials via API Keys
# ------------------------------------------
variable access_key {
  description = "The API Access key to AWS"
  default="xxxx"
}

variable secret_key {
  description = "The API Secret key to AWS"
  default="xxxx"
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "us-east-2"
}


# ------------------------------------------
# Specialized userdata declarations
# ------------------------------------------

variable "windows_userdata" {
  description = "Provides the ability to change the userdata script for custom bootups"
  default = "../../cloud-init/armor_install_win2012-16.yml"
}

variable "linux_userdata" {
  description = "Provides the ability to change the userdata script for custom bootups"
  default = "../../cloud-init/armor_install_register.yml"
}

variable "ubuntu_userdata" {
  description = "Provides the ability to change the userdata script for custom bootups"
  default = "../../cloud-init/armor_install_register_debian.yml"
}




variable "instance_type" {
  description = "The default instance size"
  default = "t2.medium"
}


variable "winrm_user" {
  description = "The winrm user we login as"
  default = "terraform"
}

variable "winrm_pass" {
  description = "The winrm user password"
  default = "terraform"
}



# ------------------------------------------
# AWS Facts & Data Source Declarations
# ------------------------------------------
variable vpc_id {
  description = "The VPC we are using which provides connectivity from our Lab to AWS"
  default="vpc-xxxx"
}

variable "private_subnet_cidr" {
  description = "CIDR for the Private Subnet"
  default = "10.0.6.0/24"
}
variable "key_name" {
  description = "Name of the SSH keypair to use in AWS."
  default = "armor_automation"
}


variable "subnet_id" {
  description = "The subnet we are using"
  default = "subnet-xxxx"
}

variable "secgroup_id" {
  description = "The security group"
  default = "sg-xxxx"
}

