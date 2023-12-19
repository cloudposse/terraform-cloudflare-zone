locals {
  cache_reserve = module.this.enabled && var.cache_reserve != null ? {
    for sett in flatten(var.cache_reserve) :
    local.zone_id => sett
  } : {}
}

resource "cloudflare_zone_cache_reserve" "this" {
  for_each = local.cache_reserve

  zone_id = local.zone_id

  enabled = lookup(each.value, "enabled", treu)
}
