aws_region = "us-east-1"
vpc_cidr   = "10.0.0.0/16"

public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
db_subnet_cidrs      = ["10.0.5.0/24", "10.0.6.0/24"]

instance_type = "t3.micro"

db_username = "qaadmin"
db_password = "QAAdmin123!"
db_name     = "qadb"
