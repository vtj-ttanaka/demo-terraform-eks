module "vpc" {
  source = "../../modules/vpc"

  vpc_name             = "my-vpc-prod"
  vpc_cidr             = "10.1.0.0/16"
  availability_zones   = ["ap-northeast-1a", "ap-northeast-1c"]
  public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnet_cidrs = ["10.1.11.0/24", "10.1.12.0/24"]

  tags = {
    Environment = "prod"
    Project     = "MyProject"
  }
}

module "eks" {
  source = "../../modules/eks"

  cluster_name            = "my-cluster-prod"
  cluster_version         = "1.32"
  subnet_ids              = concat(module.vpc.public_subnet_ids, module.vpc.private_subnet_ids)
  private_subnet_ids      = module.vpc.private_subnet_ids
  endpoint_private_access = true
  endpoint_public_access  = true

  # 本番環境は大規模
  node_instance_type = "t3.large"
  node_desired_size  = 3
  node_min_size      = 2
  node_max_size      = 5
  disk_size          = 50

  tags = {
    Environment = "prod"
    Project     = "MyProject"
  }
}

module "ecr" {
  source = "../../modules/ecr"

  repository_names = [
    "my-app-frontend-prod",
    "my-app-backend-prod",
    "my-app-worker-prod"
  ]

  image_tag_mutability    = "IMMUTABLE"
  scan_on_push            = true
  enable_lifecycle_policy = true
  image_count_to_keep     = 30

  tags = {
    Environment = "prod"
    Project     = "MyProject"
  }
}
