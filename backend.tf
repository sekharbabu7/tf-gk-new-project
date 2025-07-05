terraform {
  backend "s3" {
    bucket         = "my-terraform-backend-bucket"
    key            = "envs/dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
