provider "aws" {
  region = "us-west-2"
}

resource "aws_eks_cluster" "example" {
  name     = "example"
  role_arn = aws_iam_role.example.arn
  vpc_config {
    subnet_ids = [aws_subnet.example1.id, aws_subnet.example2.id]
  }
}

resource "aws_iam_role" "example" {
  name = "example"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "example" {
  name = "example"
  role = aws_iam_role.example.name
}

resource "aws_security_group" "example" {
  name_prefix = "example"
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = "example"
  instance_type   = "t3.medium"
  ami_type        = "AL2_x86_64"
  min_size        = 1
  max_size        = 3
  desired_size    = 2
  subnet_ids      = [aws_subnet.example1.id, aws_subnet.example.id]
  capacity_type   = "SPOT"
  spot_instance_pools = 2

  instance_profile_name = aws_iam_instance_profile.example.name
  remote_access {
    ec2_ssh_key = "example"
    source_security_group_ids = [aws_security_group.example.id]
  }
}

resource "kubernetes_deployment" "example" {
  metadata {
    name = "example"
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "example"
      }
    }

    template {
      metadata {
        labels = {
          app = "example"
        }
      }

      spec {
        container {
          name  = "example"
          image = "jfrog.example.com/example:latest"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "example" {
  metadata {
    name = "example"
  }

  spec {
    selector = {
      app = kubernetes_deployment.example.metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = kubernetes_deployment.example.spec[0].template[0].spec[0].container[0].port[0].container_port
    }

    type = "LoadBalancer"
  }
}

data "external" "fetch_docker_image" {
  program = ["sh", "-c", <<EOF
    curl -u <username>:<password> -O <repository_url>/<image_name>:<image_version>
    echo -n "{\"image_path\": \"${repository_url}/${image_name}:${image_version}\"}"
EOF
  ]
}

output "docker_image_path" {
  value = data.external.fetch_docker_image.result.image_path
}

## Replace <username>, <password>, <repository_url>, <image_name>, and <image_version> with your JFrog Artifactory credentials and Docker image details

data "terraform_remote_state" "fetch_docker_image" {
  backend = "local"

  config = {
    path = "fetch_docker_image.tfstate"
  }
}

resource "kubernetes_deployment" "example" {
  # ...

  spec {
    # ...

    template {
      # ...

      spec {
        container {
          name  = "example"
          image = data.terraform_remote_state.fetch_docker_image.outputs.docker_image_path
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}
