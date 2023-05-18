variable "zone" {
  type        = string
  description = "The DNS zone name which will be added."
}

variable "account_id" {
  type        = string
  description = "Cloudflare account ID to manage the zone resource in"
}
