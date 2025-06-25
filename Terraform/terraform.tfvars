aws_region = "ap-northeast-2"


vpc_name        = "global-vpc"
vpc_cidr_block  = "10.0.0.0/16"
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
azs             = ["ap-northeast-2a", "ap-northeast-2c"]
domain_name     = "grosmichel.click"
origin_domain_name = "team5-db-cache.s3.ap-northeast-2.amazonaws.com"
bucket_name          = "team5-db-cache"

region = "ap-northeast-2"
project_id = "team5-onprem-test"  # 예시값
onprem_api_url = "http://192.168.100.10:8080/logs"
