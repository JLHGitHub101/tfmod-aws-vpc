provider "aws" {
  region = var.region
}

locals {
  common_tags = merge(var.tags, {
    ManagedBy = "terraform"
    Module    = "tfmod-aws-vpc"
  })

  public_subnets  = zipmap(var.availability_zones, var.public_subnet_cidrs)
  compute_subnets = zipmap(var.availability_zones, var.compute_subnet_cidrs)
  rds_subnets     = zipmap(var.availability_zones, var.rds_subnet_cidrs)
}

# ---------------------------------------------------------------------------
# VPC
# ---------------------------------------------------------------------------

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(local.common_tags, {
    Name = "${var.name}-vpc"
  })
}

# ---------------------------------------------------------------------------
# Internet Gateway
# ---------------------------------------------------------------------------

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, {
    Name = "${var.name}-igw"
  })
}

# ---------------------------------------------------------------------------
# Public Subnets (one per AZ)
# ---------------------------------------------------------------------------

resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${var.name}-public-${each.key}"
    Tier = "public"
  })
}

# ---------------------------------------------------------------------------
# Compute Subnets (private, one per AZ)
# ---------------------------------------------------------------------------

resource "aws_subnet" "compute" {
  for_each = local.compute_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = merge(local.common_tags, {
    Name = "${var.name}-compute-${each.key}"
    Tier = "compute"
  })
}

# ---------------------------------------------------------------------------
# RDS Subnets (private, one per AZ)
# ---------------------------------------------------------------------------

resource "aws_subnet" "rds" {
  for_each = local.rds_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = merge(local.common_tags, {
    Name = "${var.name}-rds-${each.key}"
    Tier = "rds"
  })
}

# ---------------------------------------------------------------------------
# Route Tables
# ---------------------------------------------------------------------------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(local.common_tags, {
    Name = "${var.name}-public-rt"
  })
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, {
    Name = "${var.name}-private-rt"
  })
}

# ---------------------------------------------------------------------------
# Route Table Associations
# ---------------------------------------------------------------------------

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "compute" {
  for_each = aws_subnet.compute

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "rds" {
  for_each = aws_subnet.rds

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}
