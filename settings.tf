locals {
  settings = { for sett in var.settings : local.zone_id => sett }
}
resource "cloudflare_zone_settings_override" "this" {
  for_each = local.settings

  zone_id = local.zone_id

  settings {
    always_use_https  = lookup(each.value, "always_use_https", "on")
    ssl               = lookup(each.value, "ssl", "full")
    prefetch_preload  = lookup(each.value, "prefetch_preload", null)
    browser_cache_ttl = lookup(each.value, "browser_cache_ttl", "0")
  }
}
