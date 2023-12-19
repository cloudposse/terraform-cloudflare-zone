locals {
  argo = module.this.enabled && var.argo != null ? {
    for sett in flatten(var.argo) :
    local.zone_id => sett
  } : {}
}

resource "cloudflare_argo" "this" {
  for_each = local.argo

  zone_id = local.zone_id

  tiered_caching = lookup(each.value.argo, "tiered_caching", "off")
  smart_routing  = lookup(each.value.argo, "smart_routing", "off")
}
