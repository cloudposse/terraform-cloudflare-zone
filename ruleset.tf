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
        # for_each = lookup(rules.value, "ratelimit", null) == null ? {} : rules.value.ratelimit
        for_each = lookup(rules.value, "ratelimit", null) == null ? [] : [lookup(rules.value, "ratelimit", {})]

        content {
          characteristics     = lookup(ratelimit.value, "characteristics", null)
          period              = lookup(ratelimit.value, "period", null)
          requests_per_period = lookup(ratelimit.value, "requests_per_period", null)
          mitigation_timeout  = lookup(ratelimit.value, "mitigation_timeout", null)
          requests_to_origin  = lookup(ratelimit.value, "requests_to_origin", null)
        }
      }

      dynamic "action_parameters" {
        for_each = lookup(rules.value, "action_parameters", null) == null ? [] : [rules.value.action_parameters]

        content {}
      }

      expression  = lookup(rules.value, "expression", null)
      description = lookup(rules.value, "description", null)
      enabled     = lookup(rules.value, "enabled", null)
    }
  }
}
