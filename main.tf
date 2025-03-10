provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

# Create an EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-01f5a0b78d6089704"  # Replace with a valid AMI ID
  instance_type = "t2.micro"
}

# =============================
# IAM Role for Lambda Function
# =============================
resource "aws_iam_role" "lambda_role" {
  name = "lambda_stop_ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# IAM Policy for Lambda (Allow Stopping EC2)
resource "aws_iam_policy" "lambda_policy" {
  name = "lambda_stop_ec2_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action   = ["ec2:StopInstances"]
      Effect   = "Allow"
      Resource = "*"
    }]
  })
}

# Attach IAM Policy to Role
resource "aws_iam_role_policy_attachment" "attach_lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# =============================
# Lambda Function to Stop EC2
# =============================
resource "aws_lambda_function" "stop_idle_ec2" {
  filename      = "lambda_function.zip"  # Ensure this file exists in the same directory
  function_name = "StopIdleEC2"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  timeout       = 10

  environment {
    variables = {
      INSTANCE_ID = "i-038458391bc7a83fc"  # Replace with your EC2 instance ID
    }
  }
}

# =============================
# SNS Topic for CloudWatch Alarm
# =============================
resource "aws_sns_topic" "stop_ec2_alerts" {
  name = "stop-ec2-alerts"
}

# Subscribe Lambda to SNS Topic
resource "aws_sns_topic_subscription" "lambda_subscription" {
  topic_arn = aws_sns_topic.stop_ec2_alerts.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.stop_idle_ec2.arn
}

# Allow SNS to invoke Lambda
resource "aws_lambda_permission" "allow_sns_to_invoke_lambda" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop_idle_ec2.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.stop_ec2_alerts.arn
}

# =============================
# CloudWatch Alarm to Trigger SNS
# =============================
resource "aws_cloudwatch_metric_alarm" "idle_ec2" {
  alarm_name          = "IdleEC2Instance"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace          = "AWS/EC2"
  period             = 300  # 5 minutes
  statistic         = "Average"
  threshold          = 5
  unit               = "Percent"
  alarm_actions     = [aws_sns_topic.stop_ec2_alerts.arn]  # Use SNS ARN instead of Lambda ARN
  dimensions = {
    InstanceId = "i-038458391bc7a83fc"  # Replace with your EC2 instance ID
  }
}
