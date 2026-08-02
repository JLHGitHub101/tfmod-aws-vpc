variable "name" {
  description = "Name prefix applied to all resources created by this module."
  type        = string
  default     = "main"
}

variable "region" {
  description = "AWS region in which to create resources."
  type        = string
  default     = "us-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.20.0.0/20"
}

variable "availability_zones" {
  description = "Ordered list of Availability Zones to use. Must contain exactly 2 entries."
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "Exactly 2 Availability Zones must be specified."
  }
}

variable "compute_subnet_cidrs" {
  description = "CIDR blocks for the compute (private) subnets, one per Availability Zone. Each must be a /23."
  type        = list(string)
  default     = ["10.20.0.0/23", "10.20.2.0/23"]

  validation {
    condition     = length(var.compute_subnet_cidrs) == 2
    error_message = "Exactly 2 compute subnet CIDRs must be provided (one per AZ)."
  }
}

variable "rds_subnet_cidrs" {
  description = "CIDR blocks for the RDS (private) subnets, one per Availability Zone. Each must be a /23."
  type        = list(string)
  default     = ["10.20.4.0/23", "10.20.6.0/23"]

  validation {
    condition     = length(var.rds_subnet_cidrs) == 2
    error_message = "Exactly 2 RDS subnet CIDRs must be provided (one per AZ)."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets, one per Availability Zone. Each must be a /23."
  type        = list(string)
  default     = ["10.20.8.0/23", "10.20.10.0/23"]

  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Exactly 2 public subnet CIDRs must be provided (one per AZ)."
  }
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC."
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to merge onto every resource."
  type        = map(string)
  default     = {}
}
