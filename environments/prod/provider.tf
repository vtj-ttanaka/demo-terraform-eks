terraform {
  required_version = "~> 1.13.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.20.0"
    }
  }

  backend "s3" {
    bucket       = "my-terraform-state-prod-960052897027"
    key          = "eks-cluster/terraform.tfstate"
    region       = "ap-northeast-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = "ap-northeast-1"
  # 開発環境用のAWSアカウント
}
