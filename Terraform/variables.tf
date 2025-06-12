variable "aws_region" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "vpc_name" {}
variable "vpc_cidr_block" {}
variable "public_subnets" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
variable "azs" {
  type = list(string)
}

variable "domain_name" {
  description = "Route53에서 사용할 도메인 이름 (예: grosmichel.click)"
  type        = string
}

variable "cluster_name" {
  description = "gros_michel_EKS"
  type        = string
  default     = "gros-cluster"
}

variable "cluster_version" {
  description = "1.32"
  type        = string
  default     = "1.29"
}


