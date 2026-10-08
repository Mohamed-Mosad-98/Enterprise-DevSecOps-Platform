resource "helm_release" "aws_load_balancer_controller" {

  name = "aws-load-balancer-controller"

  repository = "https://aws.github.io/eks-charts"

  chart = "aws-load-balancer-controller"

  namespace = "kube-system"

  create_namespace = false

  version = "1.13.0"

  wait    = true
  timeout = 600
  atomic  = true

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "region"
    value = var.region
  }

  set {
    name  = "vpcId"
    value = var.vpc_id
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {

    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }


  set {

    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.service_account_role_arn
  }
}