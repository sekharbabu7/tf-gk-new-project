# Output the ALB DNS name
output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.app_alb.dns_name
}

# Output the RDS endpoint
output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.rds.endpoint
}

# Output the VPC ID
output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.main.id
}

# Output public subnet IDs
output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

# Output private subnet IDs
output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

# Output DB subnet IDs
output "db_subnet_ids" {
  description = "The IDs of the DB subnets"
  value       = [aws_subnet.db_1.id, aws_subnet.db_2.id]
}
