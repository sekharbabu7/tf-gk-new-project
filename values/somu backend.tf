terraform {
  backend "s3" {
    bucket         = "terraform-backend-somu-bucket" # Replace with actual bucket name
    key            = "envs/somu/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks-somu" # Replace with actual DynamoDB table name
  }
}
