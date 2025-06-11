terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
  backend "s3" {
    bucket = "eks-app-terraform-state-bucket"
    key = "eks-app/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
  }
}

provider "kubernetes" {
config_path = "~/.kube/config"
}