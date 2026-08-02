output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC."
  value       = aws_vpc.this.cidr_block
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway."
  value       = aws_internet_gateway.this.id
}

output "public_subnet_ids" {
  description = "List of IDs of the public subnets (index 0 = first AZ, index 1 = second AZ)."
  value       = aws_subnet.public[*].id
}

output "compute_subnet_ids" {
  description = "List of IDs of the compute (private) subnets (index 0 = first AZ, index 1 = second AZ)."
  value       = aws_subnet.compute[*].id
}

output "rds_subnet_ids" {
  description = "List of IDs of the RDS (private) subnets (index 0 = first AZ, index 1 = second AZ)."
  value       = aws_subnet.rds[*].id
}

output "public_route_table_id" {
  description = "The ID of the public route table."
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "The ID of the private route table shared by compute and RDS subnets."
  value       = aws_route_table.private.id
}
