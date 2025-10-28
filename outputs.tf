# Useful outputs for validation and access

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = module.alb.dns_name
}
output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

output "efs_id" {
  description = "EFS file system ID"
  value       = module.efs.efs_id
}
