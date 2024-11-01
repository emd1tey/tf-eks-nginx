terraform {
  required_version = ">= 1.4.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.7.0"    
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"    
    }
  }
}