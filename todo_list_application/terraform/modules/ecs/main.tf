variable "ecr_registry_name" { type = string }
variable "subnet_ids" { type = list(string) }

variable "skip_displaying_ip" {
  type = bool
  default = false
}

terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "values" {
  source = "../../../../terraform/global/values"
}

module "ecs" {
  source = "../../../../terraform/shared_abstract_modules/ecs"

  service_name = "${module.values.appname}_backend"
  docker_image_name = "${var.ecr_registry_name}/todo_app_back:latest"
  application_port = 30418
  healthcheck_url = "http://localhost:30418/healthcheck"
  subnet_ids = var.subnet_ids
}

output "ecs_task_public_ip" {
  value = module.ecs.ecs_task_public_ip
}