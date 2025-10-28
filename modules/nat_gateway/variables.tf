variable "vpc_id" {
  type = string
}

variable "public_subnet_id" {
  type        = string
  description = "Single public subnet ID for NAT Gateway"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs"
}
