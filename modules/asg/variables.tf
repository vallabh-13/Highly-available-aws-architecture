variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "alb_target_group_arn" {
  type = string
}

variable "alb_sg_id" {
  type = string
}

variable "efs_id" {
  type = string
}
variable "efs_dns_name" {
  type        = string
  description = "DNS name of the EFS file system"
}
