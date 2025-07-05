# somu.tfvars

aws_region = "us-east-1"
vpc_cidr   = "10.1.0.0/16"

public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.3.0/24", "10.1.4.0/24"]
db_subnet_cidrs      = ["10.1.5.0/24", "10.1.6.0/24"]

instance_type = "t3.micro"

db_username = "somu_admin"
db_password = "SomuSecurePass@2025"
db_name     = "somudb"
