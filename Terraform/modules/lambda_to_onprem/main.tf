resource "aws_cloudwatch_log_group" "app_log" {
  name              = "/aws/lambda/app-error"
  retention_in_days = 14
}

resource "aws_iam_role" "lambda_role" {
  name = "cw-to-onprem-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy_attachment" "lambda_basic_exec_role" {
  name       = "lambda-basic-execution"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "log_forwarder" {
  function_name = "lambda-to-onprem-logger"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  s3_bucket     = var.s3_bucket
  s3_key        = var.s3_key

  timeout       = 5
  memory_size   = 128

  environment {
    variables = {
      ONPREM_API_URL = var.onprem_api_url
    }
  }
}


resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.log_forwarder.function_name
  principal     = "logs.ap-northeast-2.amazonaws.com"
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

resource "aws_iam_role_policy" "lambda_s3_read" {
  name = "lambda-s3-read"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "s3:GetObject"
      ],
      Resource = "arn:aws:s3:::team5-db-backup/lambda/*"

    }]
  })
}
