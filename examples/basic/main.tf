terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# This example deploys the module using all default values, which creates:
#
#   VPC:     10.20.0.0/20  (us-west-2)
#   Subnets (each /23, spread across us-west-2a and us-west-2b):
#     compute  10.20.0.0/23  10.20.2.0/23
#     rds      10.20.4.0/23  10.20.6.0/23
#     public   10.20.8.0/23  10.20.10.0/23

module "vpc" {
  source = "../.."

  name = "example"
  tags = {
    Environment = "example"
  }
}

output "vpc_id" {
  description = "VPC ID created by the module."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = module.vpc.public_subnet_ids
}

output "compute_subnet_ids" {
  description = "Compute subnet IDs."
  value       = module.vpc.compute_subnet_ids
}

output "rds_subnet_ids" {
  description = "RDS subnet IDs."
  value       = module.vpc.rds_subnet_ids
}
