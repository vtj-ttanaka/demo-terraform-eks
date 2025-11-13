module "vpc" {
  source = "../../modules/vpc"

  vpc_name             = "my-vpc-dev"
  vpc_cidr             = "10.0.0.0/16"
  availability_zones   = ["ap-northeast-1a", "ap-northeast-1c"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

  tags = {
    Environment = "dev"
    Project     = "MyProject"
  }
}

module "eks" {
  source = "../../modules/eks"

  cluster_name            = "my-cluster-dev"
  cluster_version         = "1.33"
  subnet_ids              = concat(module.vpc.public_subnet_ids, module.vpc.private_subnet_ids)
  private_subnet_ids      = module.vpc.private_subnet_ids
  endpoint_private_access = true
  endpoint_public_access  = true

  # 開発環境は小規模
  node_instance_type = "t3.small"
  node_desired_size  = 1
  node_min_size      = 1
  node_max_size      = 2
  disk_size          = 20

  tags = {
    Environment = "dev"
    Project     = "MyProject"
  }
}

module "ecr" {
  source = "../../modules/ecr"

  repository_names = [
    "my-app-frontend-dev",
    "my-app-backend-dev",
    "my-app-worker-dev"
  ]

  image_tag_mutability    = "MUTABLE"
  scan_on_push            = true
  enable_lifecycle_policy = true
  image_count_to_keep     = 5

  tags = {
    Environment = "dev"
    Project     = "MyProject"
  }
}
