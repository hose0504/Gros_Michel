###########################################
# outputs.tf
###########################################

output "s3_bucket_name" {
  description = "The name of the S3 bucket for CloudWatch log export"
  value       = aws_s3_bucket.log_export.id
}

output "lambda_export_function_name" {
  description = "Lambda function that exports CloudWatch logs to S3"
  value       = aws_lambda_function.log_export_lambda.function_name
}

output "lambda_forwarder_function_name" {
  description = "Lambda function that sends logs to on-prem server"
  value       = aws_lambda_function.s3_log_forwarder.function_name
}

output "cloudwatch_event_rule" {
  description = "EventBridge rule that triggers export Lambda"
  value       = aws_cloudwatch_event_rule.schedule_export.name
}

output "log_export_s3_path" {
  description = "Prefix in S3 where exported logs will be stored"
  value       = "s3://${aws_s3_bucket.log_export.bucket}/exported/"
}
