variable "instance_name" {
  description = "EC2 인스턴스 및 보안 그룹 이름"
  type        = string
}

variable "ami_id" {
  description = "EC2 인스턴스에 사용할 AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 인스턴스 타입"
  type        = string
}

variable "key_name" {
  description = "접속을 위한 키 페어 이름"
  type        = string
}

variable "vpc_id" {
  description = "보안 그룹이 위치할 VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "EC2 인스턴스가 위치할 Subnet ID"
  type        = string
}

variable "allow_all_access" {
  description = "모든 포트 허용 여부 (보안 위험, true 시 전체 포트 개방)"
  type        = bool
  default     = false
}

variable "private_key_path" {
  description = "Path to private key for remote-exec"
  type        = string
}

variable "private_key_raw" {
  description = "The raw content of the private key (not the file path)"
  type        = string
  sensitive   = true
}