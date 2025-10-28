variable "domain_name" {
  type        = string
  description = "Root domain name (e.g., bhanudas-mahadik.com)"
}

variable "alb_dns_name" {
  type        = string
  description = "DNS name of the ALB"
}

variable "alb_zone_id" {
  type        = string
  description = "Hosted zone ID of the ALB"
}
