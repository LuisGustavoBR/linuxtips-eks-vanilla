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
