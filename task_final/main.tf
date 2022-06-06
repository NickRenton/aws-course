module "network" {
  source = "./network"

  http_sg_id = module.ec_2_instances.http_sg_id
}

module "iam" {
  source = "./iam"

  dynamo_db_arn = module.db.dynamo_db_arn
  s3_bucket_name = var.s3_bucket_name
}

module "messaging" {
  source = "./messaging"
}

module "db" {
  source = "./db"

  vpc_id = module.network.vpc_id
  private_subnets = module.network.private_subnets
  private_subnets_cidr = module.network.private_subnets_cidr
}

module "ec_2_instances" {
  source = "./ec_2"

  first_public_subnet_id = module.network.first_public_subnet_id
  second_public_subnet_id = module.network.second_public_subnet_id
  vpc_id = module.network.vpc_id
  first_private_subnet_id = module.network.first_private_subnet_id
  first_public_cidr = module.network.first_public_subnet_cidr
  second_public_cidr = module.network.second_public_subnet_cidr
  instance_profile_arn = module.iam.instance_profile_arn
  instance_profile_id = module.iam.instance_profile_id
  s3_bucket_name = var.s3_bucket_name
  rds_hostname = module.db.rds_hostname
}

module "routing" {
  source = "./routing"

  vpc_id = module.network.vpc_id
  first_public_subnet_id = module.network.first_public_subnet_id
  second_public_subnet_id = module.network.second_public_subnet_id
  first_private_subnet_id  = module.network.first_private_subnet_id
  second_private_subnet_id = module.network.second_private_subnet_id
  nat_instance_id          = module.ec_2_instances.nat_instance_id
  default_route_table_id = module.network.default_route_table_id
  http_sg_id = module.ec_2_instances.http_sg_id
  asg_id = module.ec_2_instances.asg_id
}