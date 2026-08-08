locals {
  default_tags = merge({
    ManagedBy = "terraform"
    Module    = "tfmod-aws-vpc"
  }, var.tags)

  public_subnets  = zipmap(var.availability_zones, var.public_subnet_cidrs)
  compute_subnets = zipmap(var.availability_zones, var.compute_subnet_cidrs)
  rds_subnets     = zipmap(var.availability_zones, var.rds_subnet_cidrs)
}
