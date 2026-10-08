module "iam_assumable_role_with_oidc" {

  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 5.0"

  create_role = true

  role_name = var.role_name

  provider_url = var.oidc_provider

  role_policy_arns = var.policy_arns

  oidc_fully_qualified_subjects = [
    "system:serviceaccount:${var.namespace}:${var.service_account_name}"
  ]

  tags = var.tags
}