# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "qa-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "qa-igw"
  }
}

# Public Subnets
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[0]
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "qa-public-subnet-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[1]
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "qa-public-subnet-2"
  }
}

# Private Subnets
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[0]
  availability_zone = "us-east-1a"

  tags = {
    Name = "qa-private-subnet-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[1]
  availability_zone = "us-east-1b"

  tags = {
    Name = "qa-private-subnet-2"
  }
}

# DB Subnets
resource "aws_subnet" "db_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnet_cidrs[0]
  availability_zone = "us-east-1a"

  tags = {
    Name = "qa-db-subnet-1"
  }
}

resource "aws_subnet" "db_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnet_cidrs[1]
  availability_zone = "us-east-1b"

  tags = {
    Name = "qa-db-subnet-2"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "qa-public-rt"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# Security Group
resource "aws_security_group" "alb_sg" {
  name        = "qa-alb-sg"
  description = "Allow HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "qa-ec2-sg"
  description = "Allow from ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Application Load Balancer
resource "aws_lb" "app_alb" {
  name               = "qa-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

# Target Group
resource "aws_lb_target_group" "tg" {
  name     = "qa-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

# Listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

# EC2 Instances
resource "aws_instance" "app1" {
  ami                    = "ami-0c02fb55956c7d316" # Amazon Linux 2 in us-east-1
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_1.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data              = file("user_data.sh")

  tags = {
    Name = "qa-app-server-1"
  }
}

resource "aws_instance" "app2" {
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_2.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data              = file("user_data.sh")

  tags = {
    Name = "qa-app-server-2"
  }
}

# Register EC2s with Target Group
resource "aws_lb_target_group_attachment" "app1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.app1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "app2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.app2.id
  port             = 80
}

# RDS Subnet Group
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "qa-db-subnet-group"
  subnet_ids = [aws_subnet.db_1.id, aws_subnet.db_2.id]

  tags = {
    Name = "qa-db-subnet-group"
  }
}

# RDS Instance
resource "aws_db_instance" "rds" {
  identifier        = "qa-rds"
  engine            = "mysql"
  instance_class    =_
