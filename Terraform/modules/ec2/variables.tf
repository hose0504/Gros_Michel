variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type        = string
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
}

variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
}

variable "instance_name" {
  description = "EC2 instance name"
  type        = string
}

variable "ami_id" {
  description = "AMI ID"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "key_name" {
  description = "Key pair name"
  type        = string
}

variable "allow_all_access" {
  description = "Allow all inbound rules"
  type        = bool
  default     = false
}

variable "subnet_id" {
  description = "Subnet to launch the EC2"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_key_path" {
  description = "Local private key file path"
  type        = string
  default     = ""
}

variable "private_key_raw" {
  description = "Raw private key string"
  type        = string
  default     = ""
}
