module "vpc" {
  source = "./modules/vpc"

  name = "${local.name_prefix}-vpc"

  cidr = var.vpc_cidr

  azs = var.availability_zones

  public_subnets = var.public_subnets

  private_subnets = var.private_subnets

  tags = local.common_tags
}
module "iam" {
  source = "./modules/iam"

  cluster_name = "${local.name_prefix}-eks"

  tags = local.common_tags
}
module "ecr" {
  source = "./modules/ecr"

  repository_name = "${local.name_prefix}-application"

  tags = local.common_tags
}
module "eks" {

  source = "./modules/eks"

  cluster_name = "${local.name_prefix}-eks"

  cluster_version = "1.33"

  vpc_id = module.vpc.vpc_id

  private_subnets = module.vpc.private_subnets

  cluster_role_arn = module.iam.cluster_role_arn

  node_role_arn = module.iam.node_role_arn

  tags = local.common_tags
}
module "ebs_csi_irsa" {

  source = "./modules/iam-irsa"

  role_name = "AmazonEKS_EBS_CSI_DriverRole"

  policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  ]

  oidc_provider_arn = module.eks.cluster_oidc_provider_arn

  oidc_provider = replace(
    module.eks.cluster_oidc_provider,
    "https://",
    ""
  )

  namespace = "kube-system"

  service_account_name = "ebs-csi-controller-sa"

  tags = local.common_tags
}
module "ebs_csi" {
  source = "./modules/ebs-csi"

  cluster_name = module.eks.cluster_name
  iam_role_arn = module.ebs_csi_irsa.iam_role_arn

  namespace = "kube-system"

  tags = local.common_tags

  depends_on = [
    module.ebs_csi_irsa
  ]
}
module "aws_load_balancer_controller_irsa" {

  source = "./modules/iam-irsa"

  role_name = "AmazonEKSLoadBalancerControllerRole"

  policy_arns = [
    aws_iam_policy.aws_load_balancer_controller.arn
  ]

  oidc_provider_arn = module.eks.cluster_oidc_provider_arn

  oidc_provider = replace(
    module.eks.cluster_oidc_provider,
    "https://",
    ""
  )

  namespace = "kube-system"

  service_account_name = "aws-load-balancer-controller"

  tags = local.common_tags
}
module "aws_load_balancer_controller" {

  source = "./modules/aws-load-balancer-controller"

  cluster_name = module.eks.cluster_name

  region = var.aws_region

  vpc_id = module.vpc.vpc_id

  service_account_role_arn = module.aws_load_balancer_controller_irsa.iam_role_arn

  depends_on = [
    module.aws_load_balancer_controller_irsa
  ]
}