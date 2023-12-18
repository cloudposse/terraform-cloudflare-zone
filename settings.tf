locals {
  settings = { for sett in var.settings : local.zone_id => sett }
}
resource "cloudflare_zone_settings_override" "this" {
  for_each = local.settings

  zone_id = local.zone_id

  dynamic "settings" {
    for_each = lookup(each.value, "settings", [])

    content {
      always_use_https = try(settings.value["always_use_https"], "on")
      ssl              = try(settings.value["ssl"], "full")
      prefetch_preload = try(settings.value["prefetch_preload"], null)
    }
  }
}
