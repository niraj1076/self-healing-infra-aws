
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name = "ec2-high-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = 2
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 60
  statistic = "Average"
  threshold = 60

  alarm_description = "Alarm when EC2 cpu exceeds 60%"
  alarm_actions = [] #lamda will be added in 4 part
  ok_actions = [  ]

  dimensions = {
    InstanceId = aws_instance.web.id
  }

}