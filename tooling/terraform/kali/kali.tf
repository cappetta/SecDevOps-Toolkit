
resource "aws_instance" "kali" {
  ami = "ami-10b19275"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet}"
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
    Name = "Pentester Subnet"
  }
}
