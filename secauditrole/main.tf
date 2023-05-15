#### To define AWS security audit role permissions using Terraform, you can utilize the aws_iam_role and aws_iam_role_policy_attachment resources. 
####Here's an example configuration that creates an IAM role with security audit permissions:
####In this example, we create an IAM role named "security-audit-role" using the aws_iam_role resource. 
####The assume_role_policy specifies that the role can be assumed by the AWS Security service.
####Next, we attach the "SecurityAudit" policy to the role using the aws_iam_role_policy_attachment resource. 
####The policy_arn specifies the ARN (Amazon Resource Name) of the predefined "SecurityAudit" policy provided by AWS.
####You can modify the configuration to use different predefined policies or customize the permissions by defining your own policy document using the aws_iam_policy resource.
resource "aws_iam_role" "security_audit_role" {
  name = "security-audit-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "security.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "security_audit_policy_attachment" {
  role       = aws_iam_role.security_audit_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

##Security Audit Managed Policy
####In this example, we define an aws_iam_policy resource named "security-audit-policy". 
####The policy block contains the policy document with the necessary permissions for security audit tasks. 
####You can customize the policy by adding more statements for other services and actions as required.
####Next, we create an aws_iam_policy_attachment resource to attach the managed policy to an existing IAM role. 
####The roles attribute specifies the role name(s) that the policy should be attached to, and the policy_arn attribute refers to the ARN of the managed policy.

resource "aws_iam_policy" "security_audit_policy" {
  name        = "security-audit-policy"
  path        = "/"
  description = "Managed policy for security audit"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Describe*",
        "s3:Get*",
        "iam:Get*",
        "cloudtrail:DescribeTrails",
        "guardduty:Get*",
        "config:Describe*"
      ],
      "Resource": "*"
    }
    // Add more statements for other services and actions as needed
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "security_audit_policy_attachment" {
  name       = "security-audit-policy-attachment"
  roles      = [aws_iam_role.security_audit_role.name]
  policy_arn = aws_iam_policy.security_audit_policy.arn
}
