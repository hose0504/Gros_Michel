module "network" {
  source          = "./modules/network"
  vpc_name        = var.vpc_name
  vpc_cidr_block  = var.vpc_cidr_block
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
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

module "web_ec2" {
  source           = "./modules/ec2"
  instance_name    = "web-ec2"
  ami_id           = "ami-0e967ff96936c0c0c"
  instance_type    = "t2.micro"
  key_name         = "key1"
  allow_all_access = true

  subnet_id        = module.network.public_subnet_ids[0] # ✅ 여기 주의
  vpc_id           = module.network.vpc_id
}

module "eks" {
  source          = "./modules/eks"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = module.network.private_subnet_ids
  vpc_id          = module.network.vpc_id
}
