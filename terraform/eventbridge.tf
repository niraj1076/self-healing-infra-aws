resource "aws_cloudwatch_event_rule" "cpu_alarm_rule" {
  name = "cpu-alarm-state-change"
  description = "Trigger Lambda when CPU alarm enters ALARM state"

  event_pattern = jsonencode({
    source = ["aws.cloudwatch"]
    "detail-type" = ["CloudWatch Alarm State Change"]
    detail = {
        state = {
            value = ["ALARM"]
        }
    }
  })
}


resource "aws_cloudwatch_event_target" "lambda_target" {
  rule = aws_cloudwatch_event_rule.cpu_alarm_rule.name
  target_id = "AutoRemediationLambda"
  arn = aws_lambda_function.auto_remediation.arn
}


resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id = "AllowExecutionFromEventBridge"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auto_remediation.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.cpu_alarm_rule.arn
}

