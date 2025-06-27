output "lambda_function_name" {
  value = aws_lambda_function.log_forwarder.function_name
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.app_log.name
}
