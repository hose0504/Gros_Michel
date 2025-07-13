output "nat_instance_eni" {
  value = aws_instance.nat_instance.primary_network_interface_id
}
