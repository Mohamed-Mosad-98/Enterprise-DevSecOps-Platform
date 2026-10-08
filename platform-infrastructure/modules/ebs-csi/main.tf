resource "helm_release" "ebs_csi_driver" {

  name       = "aws-ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"

  namespace        = var.namespace
  create_namespace = false
  version          = var.chart_version

  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.iam_role_arn
  }

  set {
    name  = "controller.serviceAccount.name"
    value = "ebs-csi-controller-sa"
  }

  wait            = true
  timeout         = 600
  atomic          = true
  cleanup_on_fail = true
}