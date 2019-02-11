
# ------------------------------------------
# Credentials via API Keys
# ------------------------------------------
variable access_key {
  description = "The API Access key to AWS"
  default="xxxxx"
}

variable secret_key {
  description = "The API Secret key to AWS"
  default="xxxx"
}



# ------------------------------------------
# Specialized windows target declarations
# ------------------------------------------

variable "windows_userdata" {
  description = "Provides the ability to change the userdata script for custom bootups"
  default = "../cloud-init/windows.setup.yml"
}

variable "instance_type" {
  description = "The default instance size"
  default = "t2.large"
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
  default = "xxxx"
}

variable "ami_win2016"{
  description = "The ami of the 2016 server asset"
  default = "ami-xxxx"
}

variable "ami_ms3_nix" {
  default = "ami-05056794734905857"
  description = "metasploitable3-ubuntu-1404"
}

variable "ami_fristileaks" {
  default = "ami-0539fa87bb2306efe"
  description = "FristiLeaks_1.3"
}

variable "ami_mrrobot" {
  default = "ami-067d428e8151617b0"
  description = "mrRobot"
}
variable "ami_sickos"
{
  default = "ami-0af37127c6324f3f4"
  description = "Sick0s1.2"
}
variable "ami_vunos"
{
  default = "ami-0b5b15c7c25534a9c"
  description = "VulnOSv2"
}
variable "ami_stapler"
{
  default = "ami-0cbf02480a95b6edd"
  description = "Stapler"
}
variable "ami_ms3_2k8"
{
  default = "ami-0da37791afc9aea77"
  description = "metasploitable3-win2k8"
}
variable "ami_skytower"
{
  default = "ami-0edaa47a082e55340"
  description = "SkyTower"
}


data "aws_ami" "ubuntu_1604" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical

}
# disable printing of AMI_ID
# output "AMI ID" {
#  value = "${data.aws_ami.ubuntu_1604.id}"
#}

