# tfmod-aws-vpc

Terraform module that provisions an AWS VPC with **compute**, **RDS**, and **public** subnet tiers spread across two Availability Zones.

## Default network layout

| Resource | CIDR | Notes |
|---|---|---|
| VPC | `10.20.0.0/20` | `us-west-2` |
| compute-us-west-2a | `10.20.0.0/23` | Private |
| compute-us-west-2b | `10.20.2.0/23` | Private |
| rds-us-west-2a | `10.20.4.0/23` | Private |
| rds-us-west-2b | `10.20.6.0/23` | Private |
| public-us-west-2a | `10.20.8.0/23` | Public, `map_public_ip_on_launch = true` |
| public-us-west-2b | `10.20.10.0/23` | Public, `map_public_ip_on_launch = true` |

Public subnets route `0.0.0.0/0` through an Internet Gateway.  
Compute and RDS subnets share a private route table (no default internet route).

## Usage

```hcl
module "vpc" {
  source = "github.com/JLHGitHub101/tfmod-aws-vpc"

  name = "prod"
  tags = {
    Environment = "production"
  }
}
```

All variables have sensible defaults that match the network layout above. Override any of them to customise the deployment.

## Requirements

| Name | Version |
|---|---|
| terraform | >= 1.3 |
| aws | >= 5.0 |

## Inputs

| Name | Description | Type | Default |
|---|---|---|---|
| `name` | Name prefix applied to all resources | `string` | `"main"` |
| `region` | AWS region | `string` | `"us-west-2"` |
| `vpc_cidr` | CIDR block for the VPC | `string` | `"10.20.0.0/20"` |
| `availability_zones` | List of exactly 2 AZs | `list(string)` | `["us-west-2a","us-west-2b"]` |
| `compute_subnet_cidrs` | /23 CIDRs for compute subnets (one per AZ) | `list(string)` | `["10.20.0.0/23","10.20.2.0/23"]` |
| `rds_subnet_cidrs` | /23 CIDRs for RDS subnets (one per AZ) | `list(string)` | `["10.20.4.0/23","10.20.6.0/23"]` |
| `public_subnet_cidrs` | /23 CIDRs for public subnets (one per AZ) | `list(string)` | `["10.20.8.0/23","10.20.10.0/23"]` |
| `enable_dns_hostnames` | Enable DNS hostnames in the VPC | `bool` | `true` |
| `enable_dns_support` | Enable DNS support in the VPC | `bool` | `true` |
| `tags` | Additional tags to merge onto every resource | `map(string)` | `{}` |

## Outputs

| Name | Description |
|---|---|
| `vpc_id` | The ID of the VPC |
| `vpc_cidr_block` | The CIDR block of the VPC |
| `internet_gateway_id` | The ID of the Internet Gateway |
| `public_subnet_ids` | List of public subnet IDs |
| `compute_subnet_ids` | List of compute subnet IDs |
| `rds_subnet_ids` | List of RDS subnet IDs |
| `public_route_table_id` | ID of the public route table |
| `private_route_table_id` | ID of the shared private route table |

## Examples

See [`examples/basic`](examples/basic/main.tf) for a complete working example using all default values.