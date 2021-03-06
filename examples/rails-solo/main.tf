provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_key_pair" "auth" {
  key_name = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "web" {
  count         = "${var.instance_count}"
  key_name      = "web-${count.index}"
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "${var.instance_size}"

  key_name = "${aws_key_pair.auth.id}"

  availability_zone = "${var.availability_zone}"

  ebs_block_device {
    device_name = "/dev/sdh"
    volume_size = "${var.ebs_data_size}"
  }

  ebs_block_device {
    device_name = "/dev/sdi"
    volume_size = "${var.ebs_mnt_size}"
  }

  ebs_block_device {
    device_name = "/dev/sdj"
    volume_size = "${var.ebs_db_size}"
  }

  connection {
    user = "ubuntu"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/ubuntu/.enginenirad"
    ]
  }

  provisioner "file" {
    source = "nginx.conf"
    destination = "/home/ubuntu/nginx.conf"
  }

  provisioner "file" {
    source = "app.conf"
    destination = "/home/ubuntu/.enginenirad/app.conf"
  }

  provisioner "file" {
    source = "configure.sh"
    destination = "/home/ubuntu/.enginenirad/configure.sh"
  }

  provisioner "file" {
    source = "deploy_key.pub"
    destination = "/home/ubuntu/.enginenirad/deploy_key.pub"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/.enginenirad/configure.sh",
      "sudo /home/ubuntu/.enginenirad/configure.sh"
    ]
  }

}
