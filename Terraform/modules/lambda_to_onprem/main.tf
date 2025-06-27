resource "aws_s3_bucket" "log_export" {
  bucket        = "aws-monitor-error"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "allow_log_put" {
  bucket = aws_s3_bucket.log_export.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid: "AllowLogsPutObject",
        Effect = "Allow",
        Principal = {
          Service = "logs.${var.region}.amazonaws.com"
        },
        Action = "s3:PutObject",
        Resource = "${aws_s3_bucket.log_export.arn}/*",
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}

resource "aws_lambda_function" "s3_log_forwarder" {
  function_name = "s3-log-to-onprem"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  s3_bucket         = var.s3_bucket
  s3_key            = var.s3_key
  source_code_hash  = filebase64sha256("lambda_function_payload.zip")

  timeout     = 10
  memory_size = 128

  environment {
    variables = {
      ONPREM_API_URL = var.onprem_api_url
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-s3-onprem-role"

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
        Resource = "${aws_s3_bucket.log_export.arn}/*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
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

resource "aws_lambda_function" "log_export_lambda" {
  function_name = "cloudwatch-to-s3-exporter"
  role          = aws_iam_role.lambda_role.arn
  handler       = "export_lambda_function.lambda_handler"
  runtime       = "python3.9"

  s3_bucket         = var.s3_bucket
  s3_key            = "export_lambda_payload.zip"
  source_code_hash  = filebase64sha256("export_lambda_payload.zip")

  timeout = 60

  environment {
    variables = {
      LOG_GROUP_NAME = "/aws/lambda/app-error"
      S3_BUCKET      = aws_s3_bucket.log_export.bucket
    }
  }
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.log_export_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule_export.arn
}

resource "aws_cloudwatch_event_rule" "schedule_export" {
  name                = "every-hour-export"
  schedule_expression = "rate(1 hour)" # 또는 cron(0 0 * * ? *) for daily
}

resource "aws_cloudwatch_event_target" "event_to_lambda" {
  rule      = aws_cloudwatch_event_rule.schedule_export.name
  arn       = aws_lambda_function.log_export_lambda.arn
}
