variable "region" {
  description = "The AWS region for deployment"
  type        = string
  default     = "ap-northeast-2"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "gros-cluster"
}

variable "cluster_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.29"
}

variable "vpc_id" {
  description = "VPC ID to deploy EKS into"
  type        = string
}

variable "public_subnets" {
  description = "List of private subnet IDs for EKS"
  type        = list(string)
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnet IDs for the EKS cluster"
}

variable "my_public_ip" {
  description = "Your public IP address for SSH access to EC2 and EKS API endpoint in CIDR format (e.g., 203.0.113.10/32)"
  type        = string
}