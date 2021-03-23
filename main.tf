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

# // Records
# resource "cloudflare_record" "this" {
#   for_each = { for rs in toset(var.records) : "${rs[0]} ${rs[3]} ${rs[1]}" => rs }
#   zone_id  = cloudflare_zone.this.id
#   name     = element(each.value, 0)
#   value    = element(each.value, 1)
#   priority = element(each.value, 2)
#   type     = element(each.value, 3)
#   proxied  = element(each.value, 4)
#   ttl      = element(each.value, 5)
# }

resource "cloudflare_argo" "default" {
  count = local.argo_enabed ? 1 : 0

  zone_id        = join("", cloudflare_zone.default.*.id)
  tiered_caching = local.tiered_caching
  smart_routing  = local.smart_routing
}
