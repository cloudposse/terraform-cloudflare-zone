locals {
  firewall_rules = module.this.enabled && var.firewall_rules != null ? {
    for indx, rule in flatten(var.firewall_rules) :
    format("%s-%s-%s",
      rule.action,
      md5(rule.expression),
      lookup(rule, "description", null) == null ? md5(format("Managed by Terraform #%d", indx)) : md5(rule.description),
    ) => rule
  } : {}
}

resource "cloudflare_filter" "default" {
  for_each = local.firewall_rules

  zone_id     = join("", cloudflare_zone.default.*.id)
  description = each.value.description
  expression  = each.value.expression
  paused      = lookup(each.value, "paused", null)
  ref         = lookup(each.value, "ref", null)
}

resource "cloudflare_firewall_rule" "default" {
  for_each = local.firewall_rules

  zone_id     = join("", cloudflare_zone.default.*.id)
  description = each.value.description
  action      = each.value.action
  priority    = lookup(each.value, "priority", null)
  paused      = lookup(each.value, "paused", null)
  products    = lookup(each.value, "products", null)

  filter_id = [
    for filter in values(cloudflare_filter.default)[*] :
    filter.id
    if filter.description == each.value.description
  ][0]

}

# output id - Filter identifier.
# output id - Firewall Rule identifier.
