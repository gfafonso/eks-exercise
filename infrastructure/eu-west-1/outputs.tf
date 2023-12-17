output "access_key-id" {
  value = aws_iam_access_key.poweruser-access_key.id
}

output "secret" {
  value     = aws_iam_access_key.poweruser-access_key.secret
  sensitive = true
}

output "user-arn" {
  value     = aws_iam_user.eks-poweruser.arn
}


output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.cluster_security_group_id
}

output "lb_role_arn" {
    value = module.lb_role.iam_role_arn
  
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}