resource "aws_iam_role" "lamda_role" {
  name_prefix = "lambda-auto-remediation-policy-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_policy" "lambda_policy" {
  name_prefix = "lambda-auto-remediation-policy-"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      # Allow Lambda to reboot EC2
      {
        Effect = "Allow"
        Action = [
          "ec2:RebootInstances",
          "ec2:DescribeInstances"
        ]
        Resource = "*"
      },

      # Allow logging
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },

      # Allow reading CloudWatch alarm details
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:DescribeAlarms"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_attach" {
  role       = aws_iam_role.lamda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

