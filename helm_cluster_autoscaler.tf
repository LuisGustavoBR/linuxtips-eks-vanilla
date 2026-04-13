resource "helm_release" "cluster_autoscaler" {

  repository = "https://kubernetes.github.io/autoscaler"

  chart = "cluster-autoscaler"
  name  = "aws-cluster-autoscaler"

  namespace        = "kube-system"
  create_namespace = true

  values = [
    yamlencode({
      replicaCount = 1
      awsRegion    = var.region
      rbac = {
        serviceAccount = {
          create = true
          annotations = {
            "eks.amazonaws.com/role-arn" = aws_iam_role.autoscaler.arn
          }
        }
      }
      autoscalingGroups = [
        {
          name    = aws_eks_node_group.main.resources[0].autoscaling_groups[0].name
          maxSize = lookup(var.auto_scale_options, "max")
          minSize = lookup(var.auto_scale_options, "min")
        }
      ]
    })
  ]

  depends_on = [
    aws_eks_cluster.main,
    aws_eks_node_group.main,
  ]
}