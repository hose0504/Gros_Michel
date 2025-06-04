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
  source         = "./modules/cdn"
  s3_domain_name = module.storage.bucket_domain
  s3_zone_id     = module.storage.bucket_zone_id
}

module "dns" {
  source             = "./modules/dns"
  cdn_domain_name    = module.cdn.cdn_domain_name
  cdn_hosted_zone_id = module.cdn.cdn_hosted_zone_id
}

