# Networking (already existing in your account)
variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }      # ≥2 AZs
variable "private_app_subnet_ids" { type = list(string) } # ≥2 AZs
variable "private_db_subnet_ids" { type = list(string) }  # ≥2 AZs

# CIDRs for SG source rules
variable "public_subnet_cidrs" { type = list(string) }
variable "private_app_subnet_cidrs" { type = list(string) }

# Misc
variable "project_name" {
  type    = string
  default = "tier3app"
}
variable "key_name" { type = string }
variable "app_port" {
  type    = number
  default = 3000
}
variable "hosted_zone_id" { type = string }
variable "domain_name" { type = string }

# RDS
variable "db_username" {
  type      = string
  sensitive = true
}
variable "db_password" {
  type      = string
  sensitive = true
}
variable "db_name" {
  type    = string
  default = "appdb"
}
