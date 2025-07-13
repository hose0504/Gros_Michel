variable "vpc_id" {}
variable "public_subnet_id" {}
variable "nat_instance_type" { default = "t3.micro" }
variable "ami_id" { default = "ami-01ad0c7a4930f0e43" }
variable "key_name" { default = null }

output "nat_instance_eni" {
  value = aws_instance.nat.primary_network_interface_id
}