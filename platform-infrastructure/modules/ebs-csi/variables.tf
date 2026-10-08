variable "cluster_name" {
  description = "Amazon EKS Cluster Name"
  type        = string
}

variable "iam_role_arn" {
  description = "IRSA IAM Role ARN"
  type        = string
}

variable "namespace" {
  description = "Namespace where the EBS CSI Driver will be installed"
  type        = string
  default     = "kube-system"
}

variable "chart_version" {
  description = "AWS EBS CSI Driver Helm Chart Version"
  type        = string
  default     = "2.39.0"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}