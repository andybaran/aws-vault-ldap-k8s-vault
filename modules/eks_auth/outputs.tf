output "token" {
  description = "Short-lived EKS authentication token derived from the AWS provider."
  value       = data.aws_eks_cluster_auth.this.token
  sensitive   = true
}
