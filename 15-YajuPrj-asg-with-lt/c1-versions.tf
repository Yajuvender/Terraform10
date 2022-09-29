
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.1.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

// This will generate random numbers who that we can attach it to any SNS Topic name or 
// any other resource. length 2 means it will generate random number till 99
resource "random_pet" "randomnumber" {
  length = 2
}