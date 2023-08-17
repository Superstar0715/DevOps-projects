backend "s3" {
    bucket         = "ecs-terraform-examplecom-state"
    key            = "example/com.tfstate"
    region         = "eu-west-1"
    encrypt        = "true"
    dynamodb_table = "ecs-terraform-remote-state-dynamodb"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
  profile = var.aws_profile
}