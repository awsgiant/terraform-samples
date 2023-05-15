provider "aws" {
  region = "us-west-2"  # Update with your desired region
}

resource "aws_config_configuration_recorder" "stepstocloud" {
  name = "stepstocloud-recorder"

  recording_group {
    all_supported = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "stepstocloud" {
  name         = "stepstocloud-channel"
  s3_bucket_name = "stepstocloud-bucket"
}

resource "aws_config_configuration_recorder" "stepstocloud_recorder" {
  name = "stepstocloud-recorder"

  recording_group {
    resource_types = [
      "AWS::EC2::Instance",
      "AWS::S3::Bucket",
      "AWS::IAM::User",
    ]
  }
}

resource "aws_config_delivery_channel" "stepstocloud_channel" {
  name              = "stepstocloud-channel"
  s3_bucket_name    = "stepstocloud-bucket"
  sns_topic_arn     = "arn:aws:sns:us-west-2:123456789012:stepstocloud-topic"
}

