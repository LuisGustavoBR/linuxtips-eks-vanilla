resource "helm_release" "node_termination_handler" {
  name      = "aws-node-termination-handler"
  namespace = "kube-system"

  chart      = "aws-node-termination-handler"
  repository = "https://aws.github.io/eks-charts/"

  values = yamlencode({
    serviceAccount = {
      annotations = {
        "eks.amazonaws.com/role-arn" = aws_iam_role.node_termination_handler.arn
      }
    }
    awsRegion                      = var.region
    queueURL                       = aws_sqs_queue.node_termination.url
    enableSqsTerminationDraining   = true
    enableSpotInterruptionDraining = true
    enableRebalanceMonitoring      = true
    enableRebalanceDraining        = true
    enableScheduledEventDraining   = true
    deleteSqsMsgIfNodeNotFound     = true
    checkTagBeforeDraining         = false
  })
}