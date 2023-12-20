locals {
  firewall_rules = module.this.enabled && var.firewall_rules != null ? {
    for rule in flatten(var.firewall_rules) :
    format("%s-%s",
      rule.action,
      md5(rule.expression),
    ) => rule
  } : null
}

resource "cloudflare_filter" "default" {
  for_each = local.firewall_rules

  zone_id     = local.zone_id
  description = each.value.description
  expression  = each.value.expression
  paused      = lookup(each.value, "paused", null)
  ref         = lookup(each.value, "ref", null)
}

resource "cloudflare_firewall_rule" "default" {
  for_each = local.firewall_rules

  zone_id     = local.zone_id
  description = each.value.description
  action      = each.value.action
  priority    = lookup(each.value, "priority", null)
  paused      = lookup(each.value, "paused", null)
  products    = lookup(each.value, "products", null)
  filter_id   = cloudflare_filter.default[each.key].id
}
