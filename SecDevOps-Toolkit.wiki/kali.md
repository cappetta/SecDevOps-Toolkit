# Terraform Kali Manifest Overview
Kali is the popular Penetration Testing Operating System.  This solution combines DevOps automation tooling with AWS cloud functionality.

## Overview
This manifest creates a new subnet and instance for the kali box.


## Configuration:
Update the variables manifest w/ the following information:

* ami - ensure this ami 
* instance_type - the variable is located in the variables manifest, it defaults to t2.micro 

resource "aws_instance" "kali" {
  ami = "ami-10b19275"
  instance_type = "${var.instance_type}"
  subnet_id = "${aws_subnet.us-east-2a_private.id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.secgroup_id}"]
  user_data = "${file("${var.linux_userdata}")}"

  tags {
    Name = "kali"
    Auto-Off = "True",
    Auto-Delete = "True"
  }

}


/*
  private Subnet
*/
resource "aws_subnet" "us-east-2a_private" {
  vpc_id = "${var.vpc_default}"

  cidr_block = "${var.private_subnet_cidr}"
  availability_zone = "us-east-2a"

  tags {
    Name = "Autoamtion Subnet"
  }
}
