variable "customer_gateway_ip" {
  description = "온프렘 공인 IP"
  type        = string
}

variable "on_prem_cidr_block" {
  description = "온프렘 네트워크 CIDR"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to attach VPN gateway"
  type        = string
}

variable "private_route_table_id" {
  description = "Private route table ID to route traffic to on-premise"
  type        = string
}


