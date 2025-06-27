###########################################
# main.tf
###########################################

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda-s3-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:GetObject"],
        Resource = "arn:aws:s3:::${var.s3_bucket}/*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateExportTask"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_s3_bucket" "log_export" {
  bucket        = "aws-monitor-error"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "allow_lambda_get_code" {
  bucket = var.s3_code_bucket_name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowLambdaToGetObject",
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action    = "s3:GetObject",
        Resource  = "arn:aws:s3:::${var.s3_code_bucket_name}/*"
      }
    ]
  })
}

resource "aws_lambda_function" "log_export_lambda" {
  function_name    = "cloudwatch-to-s3-exporter"
  role             = aws_iam_role.lambda_role.arn
  handler          = "export_lambda_function.lambda_handler"
  runtime          = "python3.9"
  s3_bucket        = var.s3_bucket
  s3_key           = var.s3_key
  source_code_hash = filebase64sha256("${path.module}/../lambda_function_payload.zip")

  timeout = 60
  environment {
    variables = {
      LOG_GROUP_NAME = "/aws/lambda/app-error"
      S3_BUCKET      = aws_s3_bucket.log_export.bucket
    }
  }
}

resource "aws_lambda_function" "s3_log_forwarder" {
  function_name    = "s3-log-to-onprem"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  s3_bucket        = var.s3_bucket
  s3_key           = var.s3_key
  source_code_hash = filebase64sha256("${path.module}/lambda_function_payload.zip")

  timeout     = 10
  memory_size = 128

  environment {
    variables = {
      ONPREM_API_URL = var.onprem_api_url
    }
  }
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_log_forwarder.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.log_export.arn
}

resource "aws_s3_bucket_notification" "notify_lambda" {
  bucket = aws_s3_bucket.log_export.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_log_forwarder.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}

resource "aws_cloudwatch_event_rule" "schedule_export" {
  name                = "every-hour-export"
  schedule_expression = "rate(1 hour)"
}

resource "aws_cloudwatch_event_target" "event_to_lambda" {
  rule = aws_cloudwatch_event_rule.schedule_export.name
  arn  = aws_lambda_function.log_export_lambda.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.log_export_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule_export.arn
}
