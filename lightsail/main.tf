provider "aws" {
  region = "us-west-2"
}

resource "aws_lightsail_instance" "stepstocloud_lightsail_instance" {
  name              = "stepstocloud-lightsail-instance"
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_2_0"
  key_pair_name     = "stepstocloud-keypair"
  availability_zone = "us-west-2a"
}

resource "aws_lightsail_static_ip" "stepstocloud_lightsail_static_ip" {
  name = "tepstocloud-lightsail-static-ip"
}

resource "aws_lightsail_instance_public_ports" "stepstocloud_lightsail_instance_public_ports" {
  instance_name = aws_lightsail_instance.stepstocloud_lightsail_instance.name
  port_info {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }
}

resource "aws_lightsail_static_ip_attachment" "stepstocloud_lightsail_static_ip_attachment" {
  static_ip_name = aws_lightsail_static_ip.stepstocloud_lightsail_static_ip.name
  instance_name  = aws_lightsail_instance.stepstocloud_lightsail_instance.name
}

resource "aws_lightsail_domain" "stepstocloud_lightsail_domain" {
  domain_name = "stepstocloud.com"
}

resource "aws_lightsail_static_ip_attachment" "stepstocloud_lightsail_domain_attachment" {
  static_ip_name = aws_lightsail_static_ip.example_lightsail_static_ip.name
  domain_name    = aws_lightsail_domain.stepstocloud_lightsail_domain.domain_name
}

resource "aws_lightsail_instance_access" "stepstocloud_lightsail_instance_access" {
  instance_name = aws_lightsail_instance.stepstocloud_lightsail_instance.name
}

resource "null_resource" "stepstocloud_null_resource" {
  provisioner "local-exec" {
    command = "echo 'Hello, World!' > index.html"
  }

  depends_on = [aws_lightsail_instance_access.stepstocloud_lightsail_instance_access]
}

resource "aws_lightsail_ssh_key_pair" "stepstocloud_lightsail_ssh_key_pair" {
  name       = "stepstocloud-keypair"
  public_key = file("~/.ssh/id_rsa.pub")
}
