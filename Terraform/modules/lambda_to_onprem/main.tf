provider "aws" {
  region = var.region
}

data "aws_region" "current" {}

resource "aws_cloudwatch_log_group" "app_log" {
  name              = var.log_group_name
  retention_in_days = 14
}

resource "aws_iam_role" "lambda_role" {
  name = "cw-to-onprem-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_basic_exec_role" {
  name       = "lambda-basic-execution"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy_attachment" "lambda_vpc_policy" {
  name       = "lambda-vpc-policy"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_lambda_function" "log_forwarder" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  s3_bucket     = var.s3_bucket
  s3_key        = var.s3_key
  timeout       = 5
  memory_size   = 128
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.log_forwarder.function_name
  principal     = "logs.${data.aws_region.current.name}.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.app_log.arn}:*"
}

resource "aws_cloudwatch_log_subscription_filter" "to_lambda" {
  name            = "log-to-lambda"
  log_group_name  = aws_cloudwatch_log_group.app_log.name
  filter_pattern  = ""
  destination_arn = aws_lambda_function.log_forwarder.arn

  depends_on = [
    aws_lambda_function.log_forwarder,
    aws_lambda_permission.allow_cloudwatch
  ]
}