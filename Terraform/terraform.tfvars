# AWS 자격 증명
aws_region = "ap-northeast-2"
region     = "ap-northeast-2"

# 네트워크 설정
vpc_name        = "global-vpc"
vpc_cidr_block  = "10.0.0.0/16"
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
azs             = ["ap-northeast-2a", "ap-northeast-2c"]

# NAT 인스턴스 설정 (✅ 필수)
nat_ami_id = "ami-01ad0c7a4930f0e43" # 또는 최신 Amazon Linux NAT AMI
key_name   = "key1"

# 도메인 및 S3
domain_name        = "grosmichel.click"
origin_domain_name = "team5-db-cache.s3.ap-northeast-2.amazonaws.com"
bucket_name        = "team5-db-cache"

# 프로젝트 / 환경
project_id  = "team5-onprem-test"
environment = "dev"

# EKS 클러스터 설정
cluster_name    = "grosmichel-cluster"
cluster_version = "1.29"

# Lambda 관련 zip 및 S3 키
log_export_lambda_zip_path = "./modules/lambda_to_onprem/export_lambda_payload.zip"
log_export_s3_key          = "export_lambda_payload.zip"

onprem_lambda_zip_path = "./modules/lambda_to_onprem/lambda_function_payload.zip"
onprem_s3_key          = "lambda_function_payload.zip"

# S3 버킷 (Lambda 코드 저장)
s3_code_bucket_name = "aws-monitor-code-bucket-123456789012"
s3_bucket           = "aws-monitor-code-bucket-123456789012"

# 온프렘 API URL
onprem_api_url = "http://112.221.198.140:10005/logs"

# SSH 개인 키
private_key_path = "./ssh/key1.pem"

nat_instance_eni = "eni-0d813ea19b1d913c2"
