variable "zone" {
  type        = string
  description = "The DNS zone name which will be added."
}

variable "paused" {
  type        = bool
  description = "Whether this zone is paused (traffic bypasses Cloudflare)"
  default     = false
}

variable "jump_start" {
  type        = bool
  description = "Whether to scan for DNS records on creation."
  default     = false
}

variable "plan" {
  type        = string
  description = "The name of the commercial plan to apply to the zone. Possible values: `free`, `pro`, `business`, `enterprise`"
  default     = "free"
}

variable "type" {
  type        = string
  description = "A full zone implies that DNS is hosted with Cloudflare. A `partial` zone is typically a partner-hosted zone or a CNAME setup. Possible values: `full`, `partial`."
  default     = "full"
}

variable "argo_enabled" {
  type        = bool
  description = "Whether to enable Cloudflare Argo for DNS zone"
  default     = true
}

variable "argo_tiered_caching_enabled" {
  type        = bool
  description = "Whether tiered caching is enabled."
  default     = true
}

variable "argo_smart_routing_enabled" {
  type        = bool
  description = "Whether smart routing is enabled."
  default     = true
}

variable "healthchecks_list" {
  type    = list(any)
  default = null
}
