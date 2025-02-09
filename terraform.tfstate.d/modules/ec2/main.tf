data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_instance" "instances" {
  count = length(var.subnet_ids)

  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[count.index]
  associate_public_ip_address = var.instance_type == "proxy" ? true : false
  key_name               = var.key_name
  security_groups        = [var.security_group_ids[count.index]]
  
  tags = {
    Name = "${var.instance_type}-instance-${count.index + 1}"
  }

  provisioner "remote-exec" {
    count = var.instance_type == "proxy" ? 1 : 0

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key_path)  
      host        = self.public_ip
    }

    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  }

  provisioner "local-exec" {
    command = "echo \"${var.instance_type}-instance-${count.index + 1}: ${self.public_ip}\" >> ../all-ips.txt"
  }

  lifecycle {
    create_before_destroy = true
  }
}
