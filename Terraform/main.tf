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
  source = "./modules/cdn"

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
  source = "./modules/cdn"

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
  source = "./modules/cdn"

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
  source = "./modules/cdn"

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
  source = "./modules/cdn"

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
  source = "./modules/cdn"

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

module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = module.network.private_subnet_ids
  vpc_id          = module.network.vpc_id
}

