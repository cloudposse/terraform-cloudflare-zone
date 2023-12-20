variable "zone" {
  type        = string
  description = "The DNS zone name which will be added."
}

variable "account_id" {
  type        = string
  description = "Cloudflare account ID to manage the zone resource in"
}

variable "zone_enabled" {
  type        = bool
  description = "Whether to create DNS zone otherwise use existing."
  default     = true
}

variable "records" {
  type        = list(any)
  default     = []
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

  validation {
    condition     = var.plan == null ? true : contains(["free", "pro", "business", "enterprise"], var.plan)
    error_message = "Allowed values: `free`, `pro`, `business`, `enterprise`."
  }
}

variable "type" {
  type        = string
  description = "A full zone implies that DNS is hosted with Cloudflare. A `partial` zone is typically a partner-hosted zone or a CNAME setup. Possible values: `full`, `partial`."
  default     = "full"

  validation {
    condition     = var.type == null ? true : contains(["full", "partial"], var.type)
    error_message = "Allowed values: `full`, `partial`."
  }
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
  type        = any
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
  type = list(object({
    target   = string
    priority = optional(number)
    status   = optional(string)
    actions = object({
      always_use_https         = optional(bool)
      automatic_https_rewrites = optional(string)
      browser_cache_ttl        = optional(number)
      browser_check            = optional(string)
      bypass_cache_on_cookie   = optional(string)
      cache_by_device_type     = optional(string)
      cache_deception_armor    = optional(string)
      cache_key_fields = optional(object({
        cookie = optional(object({
          check_presence = optional(list(string))
          include        = optional(list(string))
        }))
        header = optional(object({
          check_presence = optional(list(string))
          exclude        = optional(list(string))
          include        = optional(list(string))
        }))
        host = object({
          resolved = optional(bool)
        })
        query_string = object({
          exclude = optional(list(string))
          include = optional(list(string))
          ignore  = optional(bool)
        })
      }))
      cache_level     = optional(string)
      cache_on_cookie = optional(string)
      cache_ttl_by_status = optional(object({
        codes = string
        ttl   = number
      }))
      disable_apps           = optional(bool)
      disable_performance    = optional(bool)
      disable_railgun        = optional(bool)
      disable_security       = optional(bool)
      disable_zaraz          = optional(bool)
      edge_cache_ttl         = optional(number)
      email_obfuscation      = optional(string)
      explicit_cache_control = optional(string)
      forwarding_url = optional(object({
        url         = string
        status_code = number
      }))
      host_header_override = optional(string)
      ip_geolocation       = optional(string)
      minify = optional(object({
        css  = string
        html = string
        js   = string
      }))
      mirage                      = optional(string)
      opportunistic_encryption    = optional(string)
      origin_error_page_pass_thru = optional(string)
      polish                      = optional(string)
      resolve_override            = optional(string)
      respect_strong_etag         = optional(string)
      response_buffering          = optional(string)
      rocket_loader               = optional(string)
      security_level              = optional(string)
      server_side_exclude         = optional(string)
      smart_errors                = optional(string)
      sort_query_string_for_cache = optional(string)
      ssl                         = optional(string)
      true_client_ip_header       = optional(string)
      waf                         = optional(string)
    })
  }))
  default     = null
  description = <<-DOC
  A list of maps of Page Rules.
  The values of map is fully compliant with `cloudflare_page_rule` resource.
  To get more info see https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/page_rule
  DOC
}
