variable "region" {
  default = "us-east-2"
}

variable "azs" {
  default = ["us-east-2a", "us-east-2b"]
}

variable "public_subnet_cidrs" {
  default = ["10.0.0.0/20", "10.0.16.0/20"]
}

variable "private_subnet_cidrs" {
  default = ["10.0.128.0/20", "10.0.144.0/20"]
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  default = "securepassword123"
}

variable "domain_name" {
  default = "demo.bhanudas-mahadik.com"
}
