data "aws_caller_identity" "current" {}

# Lambda Role
resource "aws_iam_role" "lambda_role" {
  name = "lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

# 로그 저장용 S3 버킷
resource "aws_s3_bucket" "log_export" {
  bucket        = "aws-monitor-error"
  force_destroy = true
}

# Lambda가 log_export 버킷 객체 접근 허용
resource "aws_s3_bucket_policy" "log_export_policy" {
  bucket = aws_s3_bucket.log_export.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowLambdaGetObjectFromSameAccount",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action   = "s3:GetObject",
        Resource = "arn:aws:s3:::${aws_s3_bucket.log_export.bucket}/*",
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}

# Lambda 코드용 S3 버킷 정책
resource "aws_s3_bucket_policy" "code_bucket_policy" {
  bucket = var.s3_code_bucket_name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowLambdaToGetCode",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action   = "s3:GetObject",
        Resource = "arn:aws:s3:::${var.s3_code_bucket_name}/*"
      }
    ]
  })
}

# Lambda: CloudWatch to S3 export
resource "aws_lambda_function" "log_export_lambda" {
  function_name    = "cloudwatch-to-s3-exporter"
  role             = aws_iam_role.lambda_role.arn
  handler          = "export_lambda_function.lambda_handler"
  runtime          = "python3.9"
  s3_bucket        = var.s3_code_bucket_name
  s3_key           = var.s3_key_exporter
  source_code_hash = filebase64sha256(var.lambda_zip_path_exporter)

  timeout = 60

  environment {
    variables = {
      LOG_GROUP_NAME = "/aws/lambda/app-error"
      S3_BUCKET      = aws_s3_bucket.log_export.bucket
    }
  }
}

# Lambda: S3 to on-prem forwarder
resource "aws_lambda_function" "s3_log_forwarder" {
  function_name    = "s3-log-to-onprem"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  s3_bucket        = var.s3_code_bucket_name
  s3_key           = var.s3_key_forwarder
  source_code_hash = filebase64sha256(var.lambda_zip_path_forwarder)

  timeout     = 10
  memory_size = 128

  environment {
    variables = {
      ONPREM_API_URL = var.onprem_api_url
    }
  }
}

# Lambda Permission: allow S3 to trigger
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_log_forwarder.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.log_export.arn
}

# S3 이벤트 → Lambda 연결
resource "aws_s3_bucket_notification" "notify_lambda" {
  bucket = aws_s3_bucket.log_export.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_log_forwarder.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}

# EventBridge 스케줄링 → Lambda 실행
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

resource "aws_iam_role_policy" "lambda_s3_access" {
  name = "lambda-s3-access"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject"
        ],
        Resource = [
          "arn:aws:s3:::${var.s3_code_bucket_name}/*",
          "arn:aws:s3:::${aws_s3_bucket.log_export.bucket}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
