terraform {
  backend "s3" {
    bucket = "bucket-remessa"
    key    = "ecs-nginx/terraform.tfstate"
    region = "us-east-2"
  }
}