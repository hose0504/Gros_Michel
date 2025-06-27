variable "lambda_zip_path" {
  description = "로컬에서 Lambda zip 파일의 경로"
  type        = string
}

variable "s3_code_bucket_name" {
  description = "Lambda 코드가 업로드되어 있는 S3 버킷 이름"
  type        = string
}

variable "s3_bucket" {
  description = "CloudWatch 로그를 export할 대상 S3 버킷 이름"
  type        = string
}

variable "s3_key" {
  description = "Lambda 코드 zip의 S3 내 키 경로"
  type        = string
}

variable "onprem_api_url" {
  description = "온프레미스 서버의 API 엔드포인트"
  type        = string
}
