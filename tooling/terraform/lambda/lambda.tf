resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags {
    Name = "terraform-aws-vpc"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

/*
  NAT Instance
*/
resource "aws_security_group" "nat" {
  name = "vpc_nat"
  description = "Allow traffic to pass from the private subnet to the internet"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${var.private_subnet_cidr}"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["${var.private_subnet_cidr}"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 5901
    to_port = 5901
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  egress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 5901
    to_port = 5901
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "NATSG"
  }
}

resource "aws_instance" "nat" {
  ami = "ami-30913f47" # this is a special ami preconfigured to do NAT
  availability_zone = "us-east-2a"
  instance_type = "m1.small"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.nat.id}"]
  subnet_id = "${aws_subnet.us-east-2_lab-public.id}"
  associate_public_ip_address = true
  source_dest_check = false

  tags {
    Name = "VPC NAT"
  }
}

resource "aws_eip" "nat" {
  instance = "${aws_instance.nat.id}"
  vpc = true
}

/*
  Public Subnet
*/
resource "aws_subnet" "us-east-2_lab-public" {
  vpc_id = "${aws_vpc.default.id}"

  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "eu-west-1a"

  tags {
    Name = "Public Subnet"
  }
}

resource "aws_route_table" "us-east-2_lab-public" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags {
    Name = "Public Subnet"
  }
}

resource "aws_route_table_association" "us-east-2_lab-public" {
  subnet_id = "${aws_subnet.us-east-2_lab-public.id}"
  route_table_id = "${aws_route_table.us-east-2_lab-public.id}"
}

/*
  Private Subnet
*/
resource "aws_subnet" "us-east-2_lab-private" {
  vpc_id = "${aws_vpc.default.id}"

  cidr_block = "${var.private_subnet_cidr}"
  availability_zone = "us-east-2a"

  tags {
    Name = "Private Subnet"
  }
}

resource "aws_route_table" "us-east-2_lab-private" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.nat.id}"
  }

  tags {
    Name = "Private Subnet"
  }
}

resource "aws_route_table_association" "us-east-2_lab-private" {
  subnet_id = "${aws_subnet.us-east-2_lab-private.id}"
  route_table_id = "${aws_route_table.us-east-2_lab-private.id}"
}




data "archive_file" "start_ec2" {
  type        = "zip"
  source_file = "./lib/start.py"
  output_path = "./zip/start.ec2.zip"
}

data "archive_file" "stop_ec2" {
  type        = "zip"
  source_file = "./lib/stop.py"
  output_path = "./zip/stop.ec2.zip"
}

data "archive_file" "delete_unamed" {
  type        = "zip"
  source_file = "./lib/delete.unamed.js"
  output_path = "./zip/delete.unamed.zip"
}

resource "aws_iam_role_policy" "logs_policy" {
  name = "logs_policy"
  role = "${aws_iam_role.iam_for_lambda.name}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": "arn:aws:logs:*:*:*",
      "Action": [
        "logs:*"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda_slack"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "node" {
  s3_bucket        = "${aws_s3_bucket.default.id}"
  runtime          = "nodejs4.3"
  function_name    = "${var.lambda_js}"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "index.handler"
  s3_key           = "${aws_s3_bucket_object.default.id}"
  source_code_hash = "${data.archive_file.delete_unamed.output_md5}"

  environment = {
    variables = {
      SLACK_API_KEY = "${var.slack_api_key}"
    }
  }
  tags = {
    "name" = "lambda_automation",
    "version" = "0.1"

  }
}

resource "aws_lambda_function" "python" {
  s3_bucket        = "${aws_s3_bucket.default.id}"
  runtime          = "python2.7"
  function_name    = "${var.lambda_python}"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "start.handler"
  s3_key           = "${aws_s3_bucket_object.default.id}"
  //  source_code_hash = "${base64sha256(file(${data.archive_file.stop_ec2}))}"
  source_code_hash = "${base64sha256(file("./zip/start.ec2.zip"))}"

  environment = {
    variables = {
      DOCKER_REGISTRY_URL = "${var.docker_url}"
    }
  }
  tags = {
    "name" = "lambda_automation",
    "version" = "0.1"

  }
}

# http://jeremievallee.com/2017/03/26/aws-lambda-terraform/
resource "aws_cloudwatch_event_rule" "check-file-event" {
  name = "check-file-event"
  description = "check-file-event"
  schedule_expression = "cron(0 1 ? * * *)"
}

resource "aws_cloudwatch_event_target" "check-file-event-lambda-target" {
  target_id = "check-file-event-lambda-target"
  rule = "${aws_cloudwatch_event_rule.check-file-event.name}"
  arn = "${aws_lambda_function.python.arn}"
  input = <<EOF
{
  "bucket": "my_bucket",
  "file_path": "path/to/file"
}
EOF
}



/*
  private Subnet
*/
resource "aws_subnet" "us-east-1a_private" {
  vpc_id = "${var.vpc_default}"

  cidr_block = "${var.private_subnet_cidr}"
  availability_zone = "us-east-1a"

  tags {
    Name = "Automation Subnet"
  }
}


resource "aws_instance" "kali" {
  ami = "ami-10b19275"
  instance_type = "${var.instance_type}"
  subnet_id = "${aws_subnet.us-east-1a_private.id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.secgroup_id}"]
  user_data = "${file("${var.cloudinit_kali}")}"

  tags {
    Name = "kali"
    Auto-Off = "False",
    Auto-Delete = "False",
    vnc = "True"
  }

}


