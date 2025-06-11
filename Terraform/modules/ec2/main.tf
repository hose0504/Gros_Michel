resource "aws_security_group" "this" {
  name        = "${var.instance_name}-sg"
  description = "Allow all traffic for ${var.instance_name}"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.allow_all_access ? [1] : []
    content {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = var.allow_all_access ? [1] : []
    content {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = {
    Name = "${var.instance_name}-sg"
  }
}

resource "aws_instance" "this" {
ami                    = var.ami_id
instance_type          = var.instance_type
subnet_id              = var.subnet_id
key_name               = var.key_name
vpc_security_group_ids = [aws_security_group.this.id] 

user_data = file("${path.root}/scripts/user.sh")

tags = {
    Name =  "terraform-nginx"
}
}
