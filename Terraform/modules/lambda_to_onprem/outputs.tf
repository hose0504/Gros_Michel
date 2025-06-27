output "log_group_name" {
  value = aws_cloudwatch_log_group.app_log.name
}

output "lambda_function_name" {
  value = aws_lambda_function.log_forwarder.function_name
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}

output "cloudwatch_subscription_filter_name" {
  value = aws_cloudwatch_log_subscription_filter.to_lambda.name
}