resource "aws_security_group" "nat_sg" {
  name        = "nat-sg"
  description = "Allow NAT traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nat_instance" {
  ami                         = var.ami_id
  instance_type              = var.nat_instance_type
  subnet_id                  = var.public_subnet_id
  associate_public_ip_address = true
  source_dest_check          = false
  key_name                   = var.key_name

  vpc_security_group_ids = [aws_security_group.nat_sg.id]

  tags = {
    Name = "NAT-Instance"
  }
}

output "nat_instance_id" {
  value = aws_instance.nat_instance.id
}

output "nat_instance_private_ip" {
  value = aws_instance.nat_instance.private_ip
}
