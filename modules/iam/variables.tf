variable "role_name" {
  description = "Name of the IAM role for EC2"
  type        = string
  default     = "EC2SSMRole"
}

variable "instance_profile_name" {
  description = "Name of the IAM instance profile"
  type        = string
  default     = "EC2SSMInstanceProfile"
}
