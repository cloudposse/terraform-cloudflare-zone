locals {
  firewall_rules = module.this.enabled && var.firewall_rules != null ? {
    for rule in flatten(var.firewall_rules) :
    format("%s-%s",
      rule.action,
      md5(rule.expression),
    ) => rule
  } : {}
}

resource "cloudflare_ruleset" "default" {
  zone_id     = local.zone_id
  name        = each.value.name
  description = each.value.description
  kind        = each.value.kind
  phase       = each.value.phase

  rules {
    for_each = local.firewall_rules
    action   = each.value.action
    action_parameters = each.value.action_parameters
    description = each.value.description
    expression  = each.value.expression
    enabled     = true
  }
}
