module "network" {
  source = "./modules/network"
}

module "nginx" {
  source         = "./modules/ec2/nginx"
  meu_ip         = var.meu_ip
  subnet_id      = module.network.public_subnet_id
  vpc_id    = module.network.vpc_id
  api_private_ip = module.api.private_ip
}

module "api" {
  source      = "./modules/ec2/api"
  meu_ip      = var.meu_ip
  subnet_id   = module.network.private_subnet_id
  vpc_id    = module.network.vpc_id
  nginx_sg_id = module.nginx.security_group_id
}

module "rds" {
  source = "./modules/rds"

  vpc_id             = module.network.vpc_id
  meu_ip             = var.meu_ip
  api_sg_id          = module.api.security_group_id
  private_subnet_ids = module.network.private_subnet_ids

  db_username = var.db_username
  db_password = var.db_password
}