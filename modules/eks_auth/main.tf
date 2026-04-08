locals {
  eks_cluster_name_parts = split(" --name ", trimspace(var.eks_cluster_name))
  eks_cluster_name_raw   = length(local.eks_cluster_name_parts) > 1 ? split(" ", trimspace(local.eks_cluster_name_parts[1]))[0] : trimspace(var.eks_cluster_name)
  resolved_cluster_name  = replace(local.eks_cluster_name_raw, "\"", "")
}

data "aws_eks_cluster" "this" {
  name = local.resolved_cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = data.aws_eks_cluster.this.name
}
