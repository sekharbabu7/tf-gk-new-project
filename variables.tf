# AWS Region
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

# VPC CIDR
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Public Subnets
variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# Private Subnets
variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

# DB Subnets
variable "db_subnet_cidrs" {
  description = "List of DB subnet CIDRs"
  type        = list(string)
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
}

# EC2 Instance Type
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

# DB Username
variable "db_username" {
  description = "Username for the RDS instance"
  type        = string
  default     = "admin"
}

# DB Password
variable "db_password" {
  description = "Password for the RDS instance"
  type        = string
  sensitive   = true
  default     = "Admin123456"
}

# DB Name
variable "db_name" {
  description = "Database name for the RDS instance"
  type        = string
  default     = "myappdb"
}
