terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region  = "us-weast-1"
  profile = "default"
}
