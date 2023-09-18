# Configuration du provider AWS

terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.16.2"
        }
    }  
}

provider "aws" {
    profile = var.aws_profile
    region  = var.aws_region
}