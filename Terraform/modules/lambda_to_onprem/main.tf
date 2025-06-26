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
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy_attachment" "lambda_basic" {
  name       = "lambda-basic-attach"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "cw_to_onprem" {
  filename         = "${path.module}/lambda_function_payload.zip"
  function_name    = "cw-log-to-onprem"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256("${path.module}/lambda_function_payload.zip")
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cw_to_onprem.function_name
  principal     = "logs.ap-northeast-2.amazonaws.com"  
  source_arn    = aws_cloudwatch_log_group.app_log.arn
}


resource "aws_cloudwatch_log_subscription_filter" "to_lambda" {
  name            = "log-to-lambda"
  log_group_name  = aws_cloudwatch_log_group.app_log.name
  filter_pattern  = "{ $.level = \"ERROR\" }"
  destination_arn = aws_lambda_function.cw_to_onprem.arn

  depends_on = [aws_lambda_permission.allow_cloudwatch]
}
