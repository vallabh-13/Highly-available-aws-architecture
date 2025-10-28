output "instance_profile_name" {
  description = "Name of the IAM instance profile for EC2"
  value       = aws_iam_instance_profile.ec2_ssm_profile.name
}

output "role_name" {
  description = "Name of the IAM role"
  value       = aws_iam_role.ec2_ssm_role.name
}
