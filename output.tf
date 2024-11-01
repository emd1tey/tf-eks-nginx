output "eks_cluster_endpoint" {
  description = "EKS Cluster Endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_oidc_provider_url" {
  description = "OIDC provider URL for the EKS cluster"
  value       = module.eks.oidc_provider
}

output "public_subnet_cidrs" {
  description = "CIDR ranges of public subnets"
  value       = module.vpc.public_subnets_cidr_blocks
}

output "private_subnet_cidrs" {
  description = "CIDR ranges of private subnets"
  value       = module.vpc.private_subnets_cidr_blocks
}

output "ingress_hostname" {
  value = kubernetes_service.nginx.status.0.load_balancer.0.ingress.0.hostname
}

output "nat_public_ips" {
  description = "Public IPs of the NAT gateways"
  value       = module.vpc.nat_public_ips
}
