aws_region         = "ap-northeast-2"
region             = "ap-northeast-2"

vpc_name           = "global-vpc"
vpc_cidr_block     = "10.0.0.0/16"
public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets    = ["10.0.101.0/24", "10.0.102.0/24"]
azs                = ["ap-northeast-2a", "ap-northeast-2c"]

domain_name        = "grosmichel.click"
origin_domain_name = "team5-db-cache.s3.ap-northeast-2.amazonaws.com"
bucket_name        = "team5-db-cache"

project_id         = "team5-onprem-test"
onprem_api_url     = "http://112.221.198.140:10005/logs"

# 💡 Lambda 관련 변수
lambda_zip_path        = "./modules/lambda_to_onprem/function.zip lambda_function.zip"
s3_key                 = "function.zip lambda_function.zip"
s3_code_bucket_name    = "aws-monitor-code-bucket-123456789012"
s3_bucket = "aws-monitor-code-bucket-123456789012"  # 로그 저장용 S3 버킷 (사용 시점 명확히 구분 필요)
