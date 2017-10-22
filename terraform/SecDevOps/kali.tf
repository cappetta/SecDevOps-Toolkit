
resource "aws_instance" "kali" {
  ami = "${data.aws_ami.kali}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.secgroup_id}"]
  user_data = "${file("${var.linux_userdata}")}"

  tags {
    Name = "kali"
    Ticket = "${var.ticket}",
    Auto-Off = "True",
    Auto-Delete = "True"
  }
  provisioner "file" {
    source      = "../shared/linux"
    destination = "/home/ec2-user/shared"
    connection {
      type     = "ssh"
      user     = "ec2-user"
      private_key = "${file("${var.key_name}")}"
      insecure = true
    }
  }
}


/*
  Public Subnet
*/
resource "aws_subnet" "us-east-2a_private" {
  vpc_id = "${var.vpc_default}"

  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "eu-west-1a"

  tags {
    Name = "Public Subnet"
  }
}
