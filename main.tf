locals {
  tiered_caching = local.argo_enabed && var.argo_tiered_caching_enabled ? "on" : "off"
  smart_routing  = local.argo_enabed && var.argo_smart_routing_enabled ? "on" : "off"
  argo_enabed    = module.this.enabled && var.argo_enabled
}

resource "cloudflare_zone" "default" {
  count = module.this.enabled ? 1 : 0

  zone       = var.zone
  paused     = var.paused
  jump_start = var.jump_start
  plan       = var.plan
  type       = var.type
}

resource "cloudflare_argo" "default" {
  count = local.argo_enabed ? 1 : 0

  zone_id        = join("", cloudflare_zone.default.*.id)
  tiered_caching = local.tiered_caching
  smart_routing  = local.smart_routing
}
