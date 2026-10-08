variable "role_name" {
  description = "IAM Role Name"
  type        = string
}

variable "policy_arns" {
  description = "IAM Policy ARNs"
  type        = list(string)
}

variable "oidc_provider_arn" {
  description = "OIDC Provider ARN"
  type        = string
}

variable "oidc_provider" {
  description = "OIDC Provider URL"
  type        = string
}

variable "namespace" {
  description = "Kubernetes Namespace"
  type        = string
}

variable "service_account_name" {
  description = "Service Account Name"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}