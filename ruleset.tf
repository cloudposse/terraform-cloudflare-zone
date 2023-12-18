locals {
  rulesets = { for rs in var.rulesets : rs.name => rs }
}
resource "cloudflare_ruleset" "default" {
  for_each = local.rulesets

  zone_id     = local.zone_id
  name        = lookup(each.value, "name", null) == null ? each.key : each.value.name
  description = lookup(each.value, "description", "Rate limit")
  kind        = lookup(each.value, "kind", "zone")
  phase       = lookup(each.value, "phase", "http_ratelimit")

  dynamic "rules" {
    for_each = lookup(each.value, "rules", [])

    content {
      action = lookup(rules.value, "action", null)

      dynamic "ratelimit" {
        for_each = lookup(rules.value, "ratelimit", null) == null ? {} : rules.value.ratelimit

        content {
          characteristics     = lookup(each.value, "characteristics", null)
          period              = lookup(each.value, "period", null)
          requests_per_period = lookup(each.value, "requests_per_period", null)
          mitigation_timeout  = lookup(each.value, "mitigation_timeout", null)
          requests_to_origin  = lookup(each.value, "requests_to_origin", null)
        }
      }

      expression  = lookup(rules.value, "expression", null)
      description = lookup(rules.value, "description", null)
      enabled     = lookup(rules.value, "enabled", null)
    }
  }
}
