provider "aws" {
  region = "us-west-2"
}

resource "aws_lambda_function" "stepstocloud_lambda" {
  filename         = "stepstocloud_lambda.zip"
  function_name    = "stepstocloud_lambda"
  role             = aws_iam_role.stepstocloud_lambda_role.arn
  handler          = "index.handler"
  runtime          = "nodejs12.x"
}

resource "aws_xray_sampling_rule" "stepstocloud_xray_sampling_rule" {
  rule_name = "stepstocloud_xray_sampling_rule"
  priority  = 1
  reservoir_size = 1
  sample_target = 1
  sample_rule = "{\"service_name\": \"${aws_lambda_function.stepstocloud_lambda.function_name}\", \"http_method\": \"*\", \"url_path\": \"*\", \"fixed_rate\": 1}"
}

resource "aws_iam_role" "example_lambda_role" {
  name = "example_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "example_lambda_role"
  }
}

resource "aws_iam_policy" "example_lambda_policy" {
  name = "example_lambda_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords"
        ]
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })

  tags = {
    Name = "example_lambda_policy"
  }
}

resource "aws_iam_role_policy_attachment" "example_lambda_role_policy_attachment" {
  policy_arn = aws_iam_policy.example_lambda_policy.arn
  role       = aws_iam_role.example_lambda_role.name
}

