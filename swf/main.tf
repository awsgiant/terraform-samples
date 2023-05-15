provider "aws" {
  region = "us-west-2"  # Update with your desired region
}

resource "aws_swf_domain" "stepstocloud_domain" {
  name = "stepstocloud-domain"
  description = "SWF domain"
  workflow_execution_retention_period_in_days = 7
}

resource "aws_swf_workflow_type" "stepstocloud_workflow_type" {
  domain = aws_swf_domain.stepstocloud_domain.name
  name = "stepstocloud-workflow"
  version = "1.0"
  description = "SWF workflow type"
}

resource "aws_swf_workflow_execution" "stepstocloud_workflow_execution" {
  domain = aws_swf_domain.stepstocloud_domain.name
  workflow_id = "stepstocloud-workflow-id"
  workflow_type = aws_swf_workflow_type.stepstocloud_workflow_type.name
  task_list = "stepstocloud-task-list"
  child_policy = "TERMINATE"
}
