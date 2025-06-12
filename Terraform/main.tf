module "network" {
  source          = "./modules/network"
  vpc_name        = var.vpc_name
  vpc_cidr_block  = var.vpc_cidr_block
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
  domain_name     = var.domain_name # ← 이거 추가
}

module "storage" {
  source = "./modules/storage"
}

module "cdn" {
  source             = "./modules/cdn"
  origin_domain_name = module.storage.bucket_domain
}

module "dns" {
  source      = "./modules/dns"
  domain_name = var.domain_name

  regions = [
    {
      name        = "seoul"
      aws_region  = "ap-northeast-2"
      cdn_domain  = module.cdn.cdn_domain_name
      cdn_zone_id = module.cdn.cdn_hosted_zone_id
    }
  ]
}

terraform {
  backend "s3" {
    bucket  = "grosmichel-terraform-state"
    key     = "global/terraform.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
  }
}

module "web_ec2" {
  source           = "./modules/ec2"
  instance_name    = "web-ec2"
  ami_id           = "ami-0e967ff96936c0c0c"
  instance_type    = "t2.micro"
  key_name         = "key1"
  allow_all_access = true

  subnet_id = module.network.public_subnet_ids[0] # ✅ 여기 주의
  vpc_id    = module.network.vpc_id
}

module "eks" {
  source          = "./modules/eks"
  cluster_name    = "gros-michel-eks"
  cluster_version = "1.29"
  vpc_id          = module.network.vpc_id
  subnet_ids      = module.network.private_subnets
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


