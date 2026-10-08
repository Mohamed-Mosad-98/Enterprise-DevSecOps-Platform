resource "aws_iam_policy" "aws_load_balancer_controller" {

  name = "AWSLoadBalancerControllerIAMPolicy"

  description = "IAM Policy for AWS Load Balancer Controller"

  policy = file(
    "${path.root}/iam-policies/aws-load-balancer-controller.json"
  )

}