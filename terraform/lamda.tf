resource "aws_lambda_function" "auto_remediation" {
  function_name = "auto-remediation-lambda"
  role          = aws_iam_role.lamda_role.arn
  handler       = "auto_remediation.lambda_handler"
  runtime       = "python3.12"

  filename         = "${path.module}/../lambda/auto_remediation.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambda/auto_remediation.zip")

  timeout = 30

  environment {
    variables = {
      INSTANCE_ID = aws_instance.web.id
    }
  }
}