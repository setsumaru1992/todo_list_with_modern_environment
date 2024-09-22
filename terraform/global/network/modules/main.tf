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
  source = "../"
}

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = [module.values.vpc_name]
  }
}

output "vpc_id" {
  value = data.aws_vpc.main.id
}

# コメントアウト理由はcheck_resource_status.pyに記載
# locals {
#   vpc_name = "main-vpc"
# }
#
# data "external" "check_vpc_status" {
#   program = ["python3", "${path.module}/../check_resource_status.py"]
#   query = {
#     resource_name = local.vpc_name
#     resource_type = "vpc"
#   }
# }
#
# resource "aws_vpc" "new_vpc" {
#   count      = data.external.check_vpc_status.result["resource_id"] != "" ? 0 : 1
#   cidr_block = "10.0.0.0/16"
#
#   tags = {
#     Name = local.vpc_name
#   }
# }
#
# output "vpc_id" {
#   value = data.external.check_vpc_status.result["resource_id"] != "" ? data.external.check_vpc_status.result["resource_id"] : aws_vpc.new_vpc[0].id
# }
#
# output "resource_id" {
#   value = data.external.check_vpc_status.result["resource_id"]
# }
#
# output "status" {
#   value = data.external.check_vpc_status.result["status"]
# }