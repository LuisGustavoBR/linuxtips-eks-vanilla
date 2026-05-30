resource "aws_security_group_rule" "nodeports" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 30000
  to_port           = 32768
  protocol          = "-1"
  description       = "Allow NodePort access to worker nodes"
  type              = "ingress"
  security_group_id = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

resource "aws_security_group_rule" "coredns_tcp" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 53
  to_port           = 53
  protocol          = "tcp"
  description       = "Allow CoreDNS TCP access to worker nodes"
  type              = "ingress"
  security_group_id = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

resource "aws_security_group_rule" "coredns_udp" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  description       = "Allow CoreDNS UDP access to worker nodes"
  type              = "ingress"
  security_group_id = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

resource "aws_security_group_rule" "port_80" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

resource "aws_security_group_rule" "port_443" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

resource "aws_security_group_rule" "port_8080" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

resource "aws_security_group_rule" "port_8443" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 8443
  to_port           = 8443
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}