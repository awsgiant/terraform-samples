provider "aws" {
  region = "us-east-1"
}

resource "aws_sagemaker_notebook_instance" "stepstocloud" {
  name           = "stepstocloud-notebook"
  instance_type  = "ml.t2.medium"
  role_arn       = aws_iam_role.sagemaker.arn
  subnet_id      = aws_subnet.private.id
  security_group_ids = [aws_security_group.sagemaker.id]
  lifecycle_config_name = "default_notebook_lifecycle_config"
}

resource "aws_iam_role" "sagemaker" {
  name = "sagemaker-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_subnet" "private" {
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "sagemaker" {
  name_prefix = "sagemaker-"

  ingress {
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sagemaker-security-group"
  }
}
