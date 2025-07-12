output "instance_id" {
  description = "생성된 EC2 인스턴스의 ID"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "생성된 EC2 인스턴스의 퍼블릭 IP"
  value       = aws_instance.this.public_ip
}
