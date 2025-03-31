variable "aws_region" {
  type    = string
  default = "us-east-1"  # À adapter
}

variable "cluster_name" {
  type    = string
  default = "observability-cluster"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

