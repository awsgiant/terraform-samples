provider "aws" {
  region = "us-west-2" # Set to your desired region
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"
  
  cluster_name = "my-stepstocloud-cluster"
  subnets      = ["mysubnet-3677893456789", "mysubnet-36778957493765"]
  
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
