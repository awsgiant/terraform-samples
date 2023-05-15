provider "aws" {
  region = "us-west-2"
}

resource "aws_efs_file_system" "stepstocloud" {
  creation_token = "stc-token"
  encrypted      = true
  performance_mode = "generalPurpose"

  tags = {
    Name = "stc-efs"
  }
}

resource "aws_efs_mount_target" "stc" {
  count = 2

  file_system_id  = aws_efs_file_system.stc.id
  subnet_id       = aws_subnet.stc[count.index].id
  security_groups = [aws_security_group.stc.id]
}

resource "aws_security_group" "stc" {
  name_prefix = "stc-efs-sg"

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_subnet" "stc" {
  count = 2

  vpc_id = aws_vpc.stc.id
  cidr_block = "10.0.${count.index + 1}.0/24"

  tags = {
    Name = "example-subnet-${count.index + 1}"
  }
}

resource "aws_vpc" "stc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "stc-vpc"
  }
}
