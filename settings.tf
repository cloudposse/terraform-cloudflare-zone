# locals {
#   settings = module.this.enabled && var.settings != [] ? {
#     for sett in flatten(var.settings) :
#     local.zone_id => sett
#   } : {}
# }

locals {
  settings = module.this.enabled && var.settings != null ? {
    for zone_id, sett in var.settings :
    zone_id => {
      always_use_https  = lookup(sett, "always_use_https", "on")
      ssl               = lookup(sett, "ssl", "full")
      prefetch_preload  = lookup(sett, "prefetch_preload", null)
      browser_cache_ttl = lookup(sett, "browser_cache_ttl", 14400)
    }
  } : {}
}
resource "cloudflare_zone_settings_override" "this" {
  for_each = local.settings

  zone_id = local.zone_id

  settings {
    always_use_https  = lookup(each.value.settings, "always_use_https", "on")
    ssl               = lookup(each.value.settings, "ssl", "full")
    prefetch_preload  = lookup(each.value.settings, "prefetch_preload", null)
    browser_cache_ttl = lookup(each.value.settings, "browser_cache_ttl", 14400)
  }
  depends_on = [
    cloudflare_zone.default
  ]
}
