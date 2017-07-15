provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "us-east-1"
}
# -------------------------------------------------
# Terraform Cmd Expected:
# terraform apply --target=aws_instance.win2016_unpatched_s3 -var 'software=googlechrome' -var 'software_unpatched=40.0.2214.91' -var 'choco_package=chrome-noupdate.40.0.2214.91.nupkg' -var 'ticket=VULN-86692'
# -------------------------------------------------
resource "aws_instance" "win2016_unpatched_s3_1" {
  ami = "${var.ami_win2016}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.secgroup_id}"]
  user_data = "${file("${var.windows_userdata}")}"
  provisioner "file" {
    source      = "/root/git/qa-scripts/aws_plugin_automation/shared"
    destination = "C:/vagrantshared"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
      timeout = "10m"
    }
  }
  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_choco_puppet.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_dependencies.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }
  provisioner "remote-exec" {
    inline = [ "echo 'downloading package from s3...'", "set aws_access_key_id=todo: enter aws_access_key","set aws_secret_access_key=todo: enter aws_secret_access_key", "aws s3 cp s3://choco-packages/${var.choco_package} ." ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }

  }
  provisioner "remote-exec" {
    inline = [ "echo 'Installing [ ${var.software} Version: ${var.version_unpatched} ] via choco'","choco install -y ${var.choco_package} -s ." ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  tags {
    Name = "win2016_unpatched_s3_1",
    Ticket = "${var.ticket}",
    Auto-Off = "True",
    Auto-Delete = "False"
  }
}

resource "aws_instance" "win2016_unpatched_s3_2" {
  ami = "${var.ami_win2016}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.secgroup_id}"]
  user_data = "${file("${var.windows_userdata}")}"
  provisioner "file" {
    source      = "/root/git/qa-scripts/aws_plugin_automation/shared"
    destination = "C:/vagrantshared"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
      timeout = "10m"
    }
  }
  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_choco_puppet.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_dependencies.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }
  provisioner "remote-exec" {
    inline = [ "echo 'downloading package from s3...'", "set aws_access_key_id=todo: enter aws_access_key","set aws_secret_access_key=todo: enter aws_secret_access_key", "aws s3 cp s3://choco-packages/${var.choco_package} ." ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }

  }
  provisioner "remote-exec" {
    inline = [ "echo 'Installing [ ${var.software} Version: ${var.version_unpatched} ] via choco'","choco install -y ${var.choco_package} -s ." ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  tags {
    Name = "win2016_unpatched_s3_2",
    Ticket = "${var.ticket}",
    Auto-Off = "True",
    Auto-Delete = "False"
  }
}

resource "aws_instance" "win2016_unpatched_s3_3" {
  ami = "${var.ami_win2016}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.secgroup_id}"]
  user_data = "${file("${var.windows_userdata}")}"
  provisioner "file" {
    source      = "/root/git/qa-scripts/aws_plugin_automation/shared"
    destination = "C:/vagrantshared"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
      timeout = "10m"
    }
  }
  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_choco_puppet.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_dependencies.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }
  provisioner "remote-exec" {
    inline = [ "echo 'downloading package from s3...'", "set aws_access_key_id=todo: enter aws_access_key","set aws_secret_access_key=todo: enter aws_secret_access_key", "aws s3 cp s3://choco-packages/${var.choco_package} ." ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }

  }
  provisioner "remote-exec" {
    inline = [ "echo 'Installing [ ${var.software} Version: ${var.version_unpatched} ] via choco'","choco install -y ${var.choco_package} -s ." ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  tags {
    Name = "win2016_unpatched_s3_3",
    Ticket = "${var.ticket}",
    Auto-Off = "True",
    Auto-Delete = "False"
  }
}

resource "aws_instance" "win2016_unpatched_s3_4" {
  ami = "${var.ami_win2016}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.secgroup_id}"]
  user_data = "${file("${var.windows_userdata}")}"
  provisioner "file" {
    source      = "/root/git/qa-scripts/aws_plugin_automation/shared"
    destination = "C:/vagrantshared"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
      timeout = "10m"
    }
  }
  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_choco_puppet.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_dependencies.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }
  provisioner "remote-exec" {
    inline = [ "echo 'downloading package from s3...'", "set aws_access_key_id=todo: enter aws_access_key","set aws_secret_access_key=todo: enter aws_secret_access_key", "aws s3 cp s3://choco-packages/${var.choco_package} ." ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }

  }
  provisioner "remote-exec" {
    inline = [ "echo 'Installing [ ${var.software} Version: ${var.version_unpatched} ] via choco'","choco install -y ${var.choco_package_name} -s ." ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  tags {
    Name = "win2016_unpatched_s3_4",
    Ticket = "${var.ticket}",
    Auto-Off = "True",
    Auto-Delete = "False"
  }
}

resource "aws_instance" "win2016_unpatched_s3_5" {
  ami = "${var.ami_win2016}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.secgroup_id}"]
  user_data = "${file("${var.windows_userdata}")}"
  provisioner "file" {
    source      = "/root/git/qa-scripts/aws_plugin_automation/shared"
    destination = "C:/vagrantshared"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
      timeout = "10m"
    }
  }
  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_choco_puppet.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_dependencies.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }
  provisioner "remote-exec" {
    inline = [ "echo 'downloading package from s3...'", "set aws_access_key_id=todo: enter aws_access_key","set aws_secret_access_key=todo: enter aws_secret_access_key", "aws s3 cp s3://choco-packages/${var.choco_package} ." ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }

  }
  provisioner "remote-exec" {
    inline = [ "echo 'Installing [ ${var.software} Version: ${var.version_unpatched} ] via choco'","choco install -y ${var.choco_package} -s ." ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  tags {
    Name = "win2016_unpatched_s3_5",
    Ticket = "${var.ticket}",
    Auto-Off = "True",
    Auto-Delete = "False"
  }
}

resource "aws_instance" "win2016_unpatched_s3_6" {
  ami = "${var.ami_win2016}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.secgroup_id}"]
  user_data = "${file("${var.windows_userdata}")}"
  provisioner "file" {
    source      = "/root/git/qa-scripts/aws_plugin_automation/shared"
    destination = "C:/vagrantshared"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
      timeout = "10m"
    }
  }
  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_choco_puppet.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_dependencies.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }
  provisioner "remote-exec" {
    inline = [ "echo 'downloading package from s3...'", "set aws_access_key_id=todo: enter aws_access_key","set aws_secret_access_key=todo: enter aws_secret_access_key", "aws s3 cp s3://choco-packages/${var.choco_package} ." ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }

  }
  provisioner "remote-exec" {
    inline = [ "echo 'Installing [ ${var.software} Version: ${var.version_unpatched} ] via choco'","choco install -y ${var.choco_package} -s ." ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  tags {
    Name = "win2016_unpatched_s3",
    Ticket = "${var.ticket}",
    Auto-Off = "True",
    Auto-Delete = "False"
  }
}

resource "aws_instance" "win2016_unpatched_s3" {
  ami = "${var.ami_win2016}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.secgroup_id}"]
  user_data = "${file("${var.windows_userdata}")}"
  provisioner "file" {
    source      = "/root/git/qa-scripts/aws_plugin_automation/shared"
    destination = "C:/vagrantshared"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
      timeout = "10m"
    }
  }
  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_choco_puppet.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_dependencies.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }
  provisioner "remote-exec" {
    inline = [ "echo 'downloading package from s3...'", "set aws_access_key_id=todo: enter aws_access_key","set aws_secret_access_key=todo: enter aws_secret_access_key", "aws s3 cp s3://choco-packages/${var.choco_package} ." ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }

  }
  provisioner "remote-exec" {
    inline = [ "echo 'Installing [ ${var.software} Version: ${var.version_unpatched} ] via choco'","choco install -y ${var.choco_package} -s ." ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  tags {
    Name = "win2016_unpatched_s3_6",
    Ticket = "${var.ticket}",
    Auto-Off = "True",
    Auto-Delete = "False"
  }
}

resource "aws_instance" "win2016_unpatched_s3_7" {
  ami = "${var.ami_win2016}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.secgroup_id}"]
  user_data = "${file("${var.windows_userdata}")}"
  provisioner "file" {
    source      = "/root/git/qa-scripts/aws_plugin_automation/shared"
    destination = "C:/vagrantshared"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
      timeout = "10m"
    }
  }
  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_choco_puppet.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_dependencies.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }
  provisioner "remote-exec" {
    inline = [ "echo 'downloading package from s3...'", "set aws_access_key_id=todo: enter aws_access_key","set aws_secret_access_key=todo: enter aws_secret_access_key", "aws s3 cp s3://choco-packages/${var.choco_package} ." ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }

  }
  provisioner "remote-exec" {
    inline = [ "echo 'Installing [ ${var.software} Version: ${var.version_unpatched} ] via choco'","choco install -y ${var.choco_package} -s ." ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  tags {
    Name = "win2016_unpatched_s3_7",
    Ticket = "${var.ticket}",
    Auto-Off = "True",
    Auto-Delete = "False"
  }
}


# -------------------------------------------------
# Terraform Cmd Expected:
# terraform apply --target=aws_instance.win2016_unpatched_feed -var 'software=googlechrome' -var 'software_unpatched=40.0.2214.91' -var 'choco_package=chrome-noupdate.40.0.2214.91.nupkg' -var 'ticket=VULN-86692'
# -------------------------------------------------
resource "aws_instance" "win2016_unpatched_feed_1" {
  ami = "${var.ami_win2016}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.secgroup_id}"]
  user_data = "${file("${var.windows_userdata}")}"
  provisioner "file" {
    source      = "/root/git/qa-scripts/aws_plugin_automation/shared"
    destination = "C:/vagrantshared"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
      timeout = "10m"
    }
  }
  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_choco_puppet.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_dependencies.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }
  provisioner "remote-exec" {
    inline = [ "echo 'Installing [ ${var.software} Version: ${var.version_unpatched} ] via choco'","choco install -y ${var.software} --version=${var.version_unpatched} --ignore-checksums" ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  tags {
    Name = "win2016_unpatched_feed",
    Ticket = "${var.ticket}",
    Auto-Off = "True",
    Auto-Delete = "False"
  }
}
resource "aws_instance" "win2016_unpatched_feed_2" {
  ami = "${var.ami_win2016}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.secgroup_id}"]
  user_data = "${file("${var.windows_userdata}")}"
  provisioner "file" {
    source      = "/root/git/qa-scripts/aws_plugin_automation/shared"
    destination = "C:/vagrantshared"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
      timeout = "10m"
    }
  }
  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_choco_puppet.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_dependencies.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }
  provisioner "remote-exec" {
    inline = [ "echo 'Installing [ ${var.software} Version: ${var.version_unpatched} ] via choco'","choco install -y ${var.software} --version=${var.version_unpatched} --ignore-checksums" ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  tags {
    Name = "win2016_unpatched_feed",
    Ticket = "${var.ticket}",
    Auto-Off = "True",
    Auto-Delete = "False"
  }
}
resource "aws_instance" "win2016_unpatched_feed_3" {
  ami = "${var.ami_win2016}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.secgroup_id}"]
  user_data = "${file("${var.windows_userdata}")}"
  provisioner "file" {
    source      = "/root/git/qa-scripts/aws_plugin_automation/shared"
    destination = "C:/vagrantshared"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
      timeout = "10m"
    }
  }
  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_choco_puppet.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_dependencies.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }
  provisioner "remote-exec" {
    inline = [ "echo 'Installing [ ${var.software} Version: ${var.version_unpatched} ] via choco'","choco install -y ${var.software} --version=${var.version_unpatched} --ignore-checksums" ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  tags {
    Name = "win2016_unpatched_feed",
    Ticket = "${var.ticket}",
    Auto-Off = "True",
    Auto-Delete = "False"
  }
}
resource "aws_instance" "win2016_unpatched_feed_4" {
  ami = "${var.ami_win2016}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.secgroup_id}"]
  user_data = "${file("${var.windows_userdata}")}"
  provisioner "file" {
    source      = "/root/git/qa-scripts/aws_plugin_automation/shared"
    destination = "C:/vagrantshared"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
      timeout = "10m"
    }
  }
  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_choco_puppet.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_dependencies.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }
  provisioner "remote-exec" {
    inline = [ "echo 'Installing [ ${var.software} Version: ${var.version_unpatched} ] via choco'","choco install -y ${var.software} --version=${var.version_unpatched} --ignore-checksums" ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  tags {
    Name = "win2016_unpatched_feed",
    Ticket = "${var.ticket}",
    Auto-Off = "True",
    Auto-Delete = "False"
  }
}
resource "aws_instance" "win2016_unpatched_feed_5" {
  ami = "${var.ami_win2016}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.secgroup_id}"]
  user_data = "${file("${var.windows_userdata}")}"
  provisioner "file" {
    source      = "/root/git/qa-scripts/aws_plugin_automation/shared"
    destination = "C:/vagrantshared"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
      timeout = "10m"
    }
  }
  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_choco_puppet.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_dependencies.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }
  provisioner "remote-exec" {
    inline = [ "echo 'Installing [ ${var.software} Version: ${var.version_unpatched} ] via choco'","choco install -y ${var.software} --version=${var.version_unpatched} --ignore-checksums" ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  tags {
    Name = "win2016_unpatched_feed",
    Ticket = "${var.ticket}",
    Auto-Off = "True",
    Auto-Delete = "False"
  }
}
resource "aws_instance" "win2016_unpatched_feed_6" {
  ami = "${var.ami_win2016}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.secgroup_id}"]
  user_data = "${file("${var.windows_userdata}")}"
  provisioner "file" {
    source      = "/root/git/qa-scripts/aws_plugin_automation/shared"
    destination = "C:/vagrantshared"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
      timeout = "10m"
    }
  }
  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_choco_puppet.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_dependencies.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }
  provisioner "remote-exec" {
    inline = [ "echo 'Installing [ ${var.software} Version: ${var.version_unpatched} ] via choco'","choco install -y ${var.software} --version=${var.version_unpatched} --ignore-checksums" ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  tags {
    Name = "win2016_unpatched_feed",
    Ticket = "${var.ticket}",
    Auto-Off = "True",
    Auto-Delete = "False"
  }
}
resource "aws_instance" "win2016_unpatched_feed_7" {
  ami = "${var.ami_win2016}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.secgroup_id}"]
  user_data = "${file("${var.windows_userdata}")}"
  provisioner "file" {
    source      = "/root/git/qa-scripts/aws_plugin_automation/shared"
    destination = "C:/vagrantshared"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
      timeout = "10m"
    }
  }
  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_choco_puppet.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_dependencies.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }
  provisioner "remote-exec" {
    inline = [ "echo 'Installing [ ${var.software} Version: ${var.version_unpatched} ] via choco'","choco install -y ${var.software} --version=${var.version_unpatched} --ignore-checksums" ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  tags {
    Name = "win2016_unpatched_feed",
    Ticket = "${var.ticket}",
    Auto-Off = "True",
    Auto-Delete = "False"
  }
}

resource "aws_instance" "win2016_patched_1" {
  ami = "${var.ami_win2016}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.secgroup_id}"]
  user_data = "${file("${var.windows_userdata}")}"
  provisioner "file" {
    source      = "/root/git/qa-scripts/aws_plugin_automation/shared"
    destination = "C:/vagrantshared"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
      timeout = "10m"
    }
  }
  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_choco_puppet.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_dependencies.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }
  provisioner "remote-exec" {
    inline = [ "echo 'Installing [ ${var.software} Version: ${var.version_patched} ] via choco'","choco install -y ${var.software} --version=${var.version_patched} --ignore-checksums" ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  tags {
    Name = "win2016_patched_1",
    Ticket = "${var.ticket}",
    Auto-Off = "True",
    Auto-Delete = "False"
  }
}
resource "aws_instance" "win2016_patched_2" {
  ami = "${var.ami_win2016}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.secgroup_id}"]
  user_data = "${file("${var.windows_userdata}")}"
  provisioner "file" {
    source      = "/root/git/qa-scripts/aws_plugin_automation/shared"
    destination = "C:/vagrantshared"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
      timeout = "10m"
    }
  }
  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_choco_puppet.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_dependencies.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }
  provisioner "remote-exec" {
    inline = [ "echo 'Installing [ ${var.software} Version: ${var.version_patched} ] via choco'","choco install -y ${var.software} --version=${var.version_patched} --ignore-checksums" ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  tags {
    Name = "win2016_patched_2",
    Ticket = "${var.ticket}",
    Auto-Off = "True",
    Auto-Delete = "False"
  }
}
resource "aws_instance" "win2016_patched_3" {
  ami = "${var.ami_win2016}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.secgroup_id}"]
  user_data = "${file("${var.windows_userdata}")}"
  provisioner "file" {
    source      = "/root/git/qa-scripts/aws_plugin_automation/shared"
    destination = "C:/vagrantshared"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
      timeout = "10m"
    }
  }
  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_choco_puppet.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_dependencies.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }
  provisioner "remote-exec" {
    inline = [ "echo 'Installing [ ${var.software} Version: ${var.version_patched} ] via choco'","choco install -y ${var.software} --version=${var.version_patched} --ignore-checksums" ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  tags {
    Name = "win2016_patched_3",
    Ticket = "${var.ticket}",
    Auto-Off = "True",
    Auto-Delete = "False"
  }
}
resource "aws_instance" "win2016_patched_4" {
  ami = "${var.ami_win2016}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.secgroup_id}"]
  user_data = "${file("${var.windows_userdata}")}"
  provisioner "file" {
    source      = "/root/git/qa-scripts/aws_plugin_automation/shared"
    destination = "C:/vagrantshared"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
      timeout = "10m"
    }
  }
  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_choco_puppet.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_dependencies.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }
  provisioner "remote-exec" {
    inline = [ "echo 'Installing [ ${var.software} Version: ${var.version_patched} ] via choco'","choco install -y ${var.software} --version=${var.version_patched} --ignore-checksums" ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  tags {
    Name = "win2016_patched_4",
    Ticket = "${var.ticket}",
    Auto-Off = "True",
    Auto-Delete = "False"
  }
}
resource "aws_instance" "win2016_patched_5" {
  ami = "${var.ami_win2016}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.secgroup_id}"]
  user_data = "${file("${var.windows_userdata}")}"
  provisioner "file" {
    source      = "/root/git/qa-scripts/aws_plugin_automation/shared"
    destination = "C:/vagrantshared"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
      timeout = "10m"
    }
  }
  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_choco_puppet.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_dependencies.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }
  provisioner "remote-exec" {
    inline = [ "echo 'Installing [ ${var.software} Version: ${var.version_patched} ] via choco'","choco install -y ${var.software} --version=${var.version_patched} --ignore-checksums" ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  tags {
    Name = "win2016_patched_5",
    Ticket = "${var.ticket}",
    Auto-Off = "True",
    Auto-Delete = "False"
  }
}
resource "aws_instance" "win2016_patched_6" {
  ami = "${var.ami_win2016}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.secgroup_id}"]
  user_data = "${file("${var.windows_userdata}")}"
  provisioner "file" {
    source      = "/root/git/qa-scripts/aws_plugin_automation/shared"
    destination = "C:/vagrantshared"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
      timeout = "10m"
    }
  }
  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_choco_puppet.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_dependencies.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }
  provisioner "remote-exec" {
    inline = [ "echo 'Installing [ ${var.software} Version: ${var.version_patched} ] via choco'","choco install -y ${var.software} --version=${var.version_patched} --ignore-checksums" ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  tags {
    Name = "win2016_patched_6",
    Ticket = "${var.ticket}",
    Auto-Off = "True",
    Auto-Delete = "False"
  }
}
resource "aws_instance" "win2016_patched_7" {
  ami = "${var.ami_win2016}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.secgroup_id}"]
  user_data = "${file("${var.windows_userdata}")}"
  provisioner "file" {
    source      = "/root/git/qa-scripts/aws_plugin_automation/shared"
    destination = "C:/vagrantshared"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
      timeout = "10m"
    }
  }
  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_choco_puppet.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  provisioner "remote-exec" {
    script      = "/root/git/qa-scripts/aws_plugin_automation/shared/shell/install_dependencies.cmd"
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }
  provisioner "remote-exec" {
    inline = [ "echo 'Installing [ ${var.software} Version: ${var.version_patched} ] via choco'","choco install -y ${var.software} --version=${var.version_patched} --ignore-checksums" ]
    connection {
      type     = "winrm"
      user     = "${var.winrm_user}"
      password     = "${var.winrm_pass}"
      insecure = true
    }
  }

  tags {
    Name = "win2016_patched_7",
    Ticket = "${var.ticket}",
    Auto-Off = "True",
    Auto-Delete = "False"
  }
}
