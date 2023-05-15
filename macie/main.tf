provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "stepstocloud_bucket" {
  bucket = "stepstocloud-bucket"
}

resource "aws_macie_s3_bucket_association" "stepstocloud_macie_bucket_association" {
  bucket_name = aws_s3_bucket.stepstocloud_bucket.id

  classification_type {
    one_time = true
    sensitive_data = {\b(?:\d[ -]*?){13,16}\b}
  }
}
