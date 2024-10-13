variable "ecr_registry_name" { type = string }

provider "aws" {
  region = "ap-northeast-1"
}

module "global_bootstrap" {
  source = "../../../../../terraform/global"
}

module "dev" {
  source = "../"
  depends_on = [module.global_bootstrap]

  ecr_registry_name = var.ecr_registry_name
}

output "alb_dns_name" {
  value = module.dev.alb_dns_name
}