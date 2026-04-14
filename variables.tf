variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

variable "profile" {
  type = string
}

variable "ssm_vpc" {
  type = string
}

variable "ssm_public_subnets" {
  type = list(string)
}

variable "ssm_private_subnets" {
  type = list(string)
}

variable "ssm_pod_subnets" {
  type = list(string)
}

variable "k8s_version" {
  type = string
}

variable "auto_scale_options" {
  type = object({
    min     = number
    max     = number
    desired = number
  })
}

variable "nodes_instance_sizes" {
  type = list(string)
}

variable "addon_cni_version" {
  type    = string
  default = "v1.21.1-eksbuild.3"
}

variable "addon_coredns_version" {
  type    = string
  default = "v1.13.2-eksbuild.1"
}

variable "addon_kubeproxy_version" {
  type    = string
  default = "v1.34.3-eksbuild.5"
}

variable "addon_pod_identity_version" {
  type    = string
  default = "v1.3.4-eksbuild.1"
}