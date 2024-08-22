locals {
  tiered_caching  = local.argo_enabled && var.argo_tiered_caching_enabled ? "on" : "off"
  smart_routing   = local.argo_enabled && var.argo_smart_routing_enabled ? "on" : "off"
  argo_enabled    = module.this.enabled && var.argo_enabled
  zone_enabled    = module.this.enabled && var.zone_enabled
  zone_exists     = module.this.enabled && !var.zone_enabled
  records_enabled = module.this.enabled && length(var.records) > 0
  zone_id         = local.zone_enabled ? join("", cloudflare_zone.default[*].id) : (local.zone_exists ? data.cloudflare_zones.default[0].zones[0].id : null)
  records = local.records_enabled ? {
    for index, record in var.records :
    try(record.key, format("%s-%s-%s", record.name, record.type, record.value)) => record
  } : {}
  records_default_proxied = var.records_default_proxied
}

data "cloudflare_zones" "default" {
  count = local.zone_exists ? 1 : 0

  filter {
    name = var.zone
  }
}

resource "cloudflare_zone" "default" {
  count = local.zone_enabled ? 1 : 0

  account_id = var.account_id
  zone       = var.zone
  paused     = var.paused
  jump_start = var.jump_start
  plan       = var.plan
  type       = var.type
}

resource "cloudflare_record" "default" {
  for_each = local.records

  zone_id  = local.zone_id
  name     = each.value.name
  type     = each.value.type
  value    = each.value.value
  comment  = lookup(each.value, "comment", null)
  priority = lookup(each.value, "priority", null)
  proxied  = lookup(each.value, "proxied", false)
  ttl      = lookup(each.value, "ttl", 1)
}

resource "cloudflare_argo" "default" {
  count = local.argo_enabled ? 1 : 0

  zone_id        = local.zone_id
  tiered_caching = local.tiered_caching
  smart_routing  = local.smart_routing
}
