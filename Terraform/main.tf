terraform {
  backend "s3" {
    bucket  = "grosmichel-terraform-state"
    key     = "global/terraform.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
  }
}

module "network" {
  source          = "./modules/network"
  vpc_name        = var.vpc_name
  vpc_cidr_block  = var.vpc_cidr_block
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
  domain_name     = var.domain_name
}

module "storage" {
  source      = "./modules/storage"
  environment = var.environment
}

module "cdn" {
  source             = "./modules/cdn"
  origin_domain_name = module.storage.bucket_domain
}

module "db_cache_cdn" {
  source              = "./modules/db_cache_cdn"
  origin_domain_name  = module.storage.bucket_domain_name
  bucket_name         = module.storage.bucket_name
  environment         = var.environment
}

resource "aws_lb" "this" {
  name               = "grosmichel-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = module.network.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "grosmichel-alb"
  }
}

module "dns" {
  source                  = "./modules/dns"
  domain_name             = var.domain_name
  alb_dns_name            = aws_lb.this.dns_name
  alb_zone_id             = aws_lb.this.zone_id
  cloudfront_domain_name = module.db_cache_cdn.cloudfront_domain_name
}

module "web_ec2" {
  source           = "./modules/ec2"
  instance_name    = "web-ec2"
  ami_id           = "ami-0e967ff96936c0c0c"
  instance_type    = "t3.small"
  key_name         = "key1"
  allow_all_access = true
  subnet_id        = module.network.public_subnet_ids[0]
  vpc_id           = module.network.vpc_id

  private_key_path = var.private_key_path
  private_key_raw  = var.private_key_raw
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.network.vpc_id
  subnet_ids      = module.network.private_subnets

  cluster_endpoint_public_access             = true
  enable_cluster_creator_admin_permissions   = true

  eks_managed_node_groups = {
    default = {
      desired_size   = 1
      max_size       = 3
      min_size       = 1
      instance_types = ["t3.small"]
    }
  }
}

module "nat_instance" {
  source           = "./modules/nat_instance"
  vpc_id           = module.network.vpc_id
  public_subnet_id = module.network.public_subnet_ids[0]
  key_name         = "key1"
}

resource "aws_route" "private_to_nat" {
  route_table_id         = module.network.private_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = module.nat_instance.nat_instance_eni_id
}

resource "aws_lb_target_group" "web_tg" {
  name        = "web-tg"
  port        = 30080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.network.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}




