output "cluster_name" {
  description = "Resolved EKS cluster name"
  value       = data.aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "EKS cluster API server endpoint"
  value       = data.aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded certificate authority data for the EKS cluster"
  value       = data.aws_eks_cluster.this.certificate_authority[0].data
}

output "token" {
  description = "Authentication token for the EKS cluster"
  value       = data.aws_eks_cluster_auth.this.token
  sensitive   = true
}
