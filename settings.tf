locals {
  settings = local.zone_enabled && var.settings != null ? {
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
    always_use_https  = each.value.always_use_https
    ssl               = each.value.ssl
    prefetch_preload  = each.value.prefetch_preload
    browser_cache_ttl = each.value.browser_cache_ttl
  }
  depends_on = [
    cloudflare_zone.default
  ]
}
