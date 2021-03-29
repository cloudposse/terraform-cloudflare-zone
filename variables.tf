variable "zone" {
  type        = string
  description = "The DNS zone name which will be added."
}

variable "zone_enabled" {
  type        = bool
  description = "Whether to create DNS zone otherwise use existing."
  default     = true
}

variable "records" {
  type        = list(any)
  default     = null
  description = <<-DOC
    name:
      The name of the record.
    type:
      The type of the record.
    value:
      The value of the record.
    ttl:
      The TTL of the record.
      Default value: 1.
    priority:
      The priority of the record. 
    proxied:
      Whether the record gets Cloudflare's origin protection. 
      Default value: false.
  DOC
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
  default     = false
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

variable "healthchecks" {
  type        = list(any)
  default     = null
  description = <<-DOC
  A list of maps of Health Checks rules. 
  The values of map is fully compliant with `cloudflare_healthcheck` resource.
  To get more info see https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/healthcheck
  DOC
}

variable "firewall_rules" {
  type        = list(any)
  default     = null
  description = <<-DOC
    paused:
      Whether this filter is currently paused.
    expression:
      The filter expression to be used.
    description:
      A note that you can use to describe the purpose of the filter and rule.
    ref:
      Short reference tag to quickly select related rules.
    action:
      The action to apply to a matched request. 
      Possible values: `block`, `challenge`, `allow`, `js_challenge`, `bypass`.
    priority:
      The priority of the rule to allow control of processing order. 
      A lower number indicates high priority.
      If not provided, any rules with a priority will be sequenced before those without.
    products:
      List of products to bypass for a request when the bypass action is used. 
      Possible values: `zoneLockdown`, `uaBlock`, `bic`, `hot`, `securityLevel`, `rateLimit`, `waf`.
  DOC
}

variable "page_rules" {
  type        = list(any)
  default     = null
  description = <<-DOC
  A list of maps of Page Rules. 
  The values of map is fully compliant with `cloudflare_page_rule` resource.
  To get more info see https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/cloudflare_page_rule
  DOC
}
