output "nat_instance_id" {
  value = aws_instance.nat_instance.id
}

output "nat_instance_private_ip" {
  value = aws_instance.nat_instance.private_ip
}

output "nat_instance_eni" {
  value = aws_instance.nat_instance.primary_network_interface_id
}
