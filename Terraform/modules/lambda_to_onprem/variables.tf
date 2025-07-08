# ✅ CloudWatch → S3 Lambda 관련
variable "lambda_zip_path_exporter" {
  description = "CloudWatch 로그를 S3로 export하는 Lambda zip 경로"
  type        = string
}

variable "s3_key_exporter" {
  description = "CloudWatch → S3 Lambda 코드의 S3 키 경로"
  type        = string
}

# ✅ S3 → 온프레미스 Lambda 관련
variable "lambda_zip_path_forwarder" {
  description = "S3에 업로드된 로그를 온프레미스로 전송하는 Lambda zip 경로"
  type        = string
}

variable "s3_key_forwarder" {
  description = "S3 → 온프레미스 Lambda 코드의 S3 키 경로"
  type        = string
}

# ✅ 공통 변수
variable "s3_code_bucket_name" {
  description = "Lambda 코드가 업로드되어 있는 S3 버킷 이름"
  type        = string
}

variable "s3_bucket" {
  description = "CloudWatch 로그를 export할 대상 S3 버킷 이름"
  type        = string
}

variable "onprem_api_url" {
  description = "온프레미스 서버의 API 엔드포인트"
  type        = string
}
