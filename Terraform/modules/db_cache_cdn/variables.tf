variable "origin_domain_name" {
  description = "Shared S3 bucket domain name"
  type        = string
}

variable "environment" {
  description = "Environment tag (e.g., dev, staging, prod)"
  type        = string
}

# variable "bucket_name" {
#   description = "The name of the shared S3 bucket"
#   type        = string
# }
