terraform {
    required_providers {
      aws = ">= 4.2.0"
    }
}

provider "aws" {
    region = "us-east-1"
}