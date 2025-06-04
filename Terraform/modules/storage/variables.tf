# 이 모듈은 외부에서 전달받을 변수가 없음.
# 필요 시 bucket_prefix 등으로 추후 확장 가능.

# 예시 (추후 필요 시):
# variable "bucket_prefix" {
#   type        = string
#   description = "S3 버킷 이름 앞에 붙일 접두사"
#   default     = "myapp"
# }
