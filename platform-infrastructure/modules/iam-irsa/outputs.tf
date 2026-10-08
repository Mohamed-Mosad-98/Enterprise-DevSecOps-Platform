output "iam_role_arn" {
  description = "IAM Role ARN"
  value       = module.iam_assumable_role_with_oidc.iam_role_arn
}

output "iam_role_name" {
  description = "IAM Role Name"
  value       = module.iam_assumable_role_with_oidc.iam_role_name
}