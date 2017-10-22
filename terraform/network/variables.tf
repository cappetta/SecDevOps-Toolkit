
# ------------------------------------------
# Credentials via API Keys
# ------------------------------------------
variable access_key {
  description = "The API Access key to AWS"
  default="xxxxx"
}

variable secret_key {
  description = "The API Secret key to AWS"
  default="xxxxx"
}

# ------------------------------------------
# Linux defaults
# ------------------------------------------
variable "linux_userdata" {
  description = "Provides the ability to change the userdata script for custom bootups"
  default = "../cloud-init/linux.setup.yml"
}

# ------------------------------------------
# AWS Facts & Data Source Declarations
# ------------------------------------------
variable vpc_id {
  description = "The VPC we are using which provides connectivity from our Lab to AWS"
  default="vpc-xxxxxx"
}

variable "subnet_id" {
  description = "The subnet we are using"
  default = "subnet-xxxxxx"
}

variable "secgroup_id" {
  description = "The security group"
  default = "sg-xxxx"
}

variable "key_name" {
  description = "Name of the SSH keypair to use in AWS."
  default = "xxxxx"
}


data "aws_ami" "kali" {
  most_recent = true

  filter {
    name = "name"
    values = ["kali"]
  }
}
# disable printing of AMI_ID
# output "AMI ID" {
#  value = "${data.aws_ami.ubuntu_1604.id}"
#}



variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default = "10.2.0.0/16"
}

variable "private_subnet_cidr" {
  description = "CIDR for the Private Subnet"
  default = "10.2.1.0/24"
}