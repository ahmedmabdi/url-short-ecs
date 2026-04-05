provider "aws" {
  region = var.aws_region
}
provider "aws" {
  alias = "us_east_1"
  region = "us-east-1"
}

module "vpc" {
  source               = "../../modules/vpc"
  vpc_name                = var.vpc_name
  vpc_cidr                = var.vpc_cidr
  azs                     = var.azs
  public_subnet_cidrs     = var.public_subnet_cidrs
  private_subnet_cidrs    = var.private_subnet_cidrs
  vpc_id                  = module.vpc.vpc_id
  private_subnet_ids      = module.vpc.private_subnet_ids
  vpc_endpoints_sg_id     = module.sg.vpc_endpoints_sg_id
  private_route_table_ids = module.vpc.private_route_table_ids
  region                  = var.aws_region
}
module "sg" {
  source       = "../../modules/sg"
  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
}

module "iam" {
  source                       = "../../modules/iam"
  environment = "staging"
  ecs_task_execution_role_name = "ecsExecutionRoleDemo"
  ecs_task_role_name           = "ecsTaskRoleDemo"
  dynamodb_table_arn           = module.dynamodb.dynamodb_table_arn
}


module "ecs" {
  source = "../../modules/ecs"

  cluster_name = "urlshort-staging-cluster"
  service_name = "urlshort-staging-service"
  task_family  = "urlshort-staging-task"
  project_name = var.project_name

  container_name  = var.container_name
  container_image = var.container_image
  container_port  = var.container_port

  execution_role_arn = module.iam.ecs_execution_role_arn
  task_role_arn      = module.iam.ecs_task_role_arn

  private_subnets  = module.vpc.private_subnet_ids
  target_group_arn = module.alb.prod_target_group_arn
  ecs_sg_id        = module.sg.ecs_sg_id
  dynamodb_table_name =  module.dynamodb.dynamodb_table_arn

  desired_count = 1
  min_count     = 1
  max_count     = 1

  task_cpu    = var.task_cpu
  task_memory = var.task_memory

  vpc_id  = module.vpc.vpc_id
  region  = var.aws_region
}
module "alb" {
  source            = "../../modules/alb"
  environment = "staging"
  name              = "URLSHORT-alb-staging"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.sg.alb_sg_id
  certificate_arn   = module.acm.alb_certificate_arn
  target_port       = 8080
}

module "acm" {

  source       = "../../modules/acm"
  zone_id      = var.route53_zone_id
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
  providers = {
    aws.us_east_1 = aws.us_east_1
  }
}

module "cloudfront" {
  source = "../../modules/cloudfront"
  environment = "staging"
  alb_dns_name              = module.alb.alb_dns_name
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  route53_zone_id           = var.route53_zone_id
  acm_certificate_arn = module.acm.cloudfront_certificate_arn

   providers = {
    aws.us_east_1 = aws.us_east_1

  }
}

module "cloudwatch" {
  source        = "../../modules/cloudwatch"
  project_name  = var.project_name
  cluster_name  = module.ecs.cluster_name
  service_name  = module.ecs.service_name
  cpu_threshold = 70
  alert_email   = "ahmed.abdi67@outlook.com"
  arn_suffix    = module.alb.alb_arn_suffix
}

module "codedeploy" {
  source = "../../modules/codedeploy"

  service_name           = module.ecs.service_name
  cluster_name           = module.ecs.cluster_name
  prod_target_group_name = module.alb.prod_target_group_name
  test_target_group_name = module.alb.test_target_group_name
  alb_https_listener_arn = [module.alb.https_listener_arn]
  alb_test_listener_arn  = [module.alb.test_listener_arn]
  env = "staging"
}

module "dynamodb" {
  source   = "../../modules/dynamodb"
  tag_name = "url-shortener"

  dynamodb_table_name         = var.dynamodb_table_name
  dynamodb_billing_mode       = var.dynamodb_billing_mode
  dynamodb_hash_key           = var.dynamodb_hash_key
  dynamodb_attribute_name     = var.dynamodb_attribute_name
  dynamodb_attribute_type     = var.dynamodb_attribute_type
  pitr_enabled                = var.pitr_enabled
  dynamodb_ttl_attribute_name = var.dynamodb_ttl_attribute_name
  dynamodb_ttl_enabled        = var.dynamodb_ttl_enabled
}