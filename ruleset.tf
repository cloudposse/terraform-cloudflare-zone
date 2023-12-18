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
      action = lookup(rules.value, "action", "block")

      dynamic "ratelimit" {
        for_each = lookup(rules.value, "ratelimit", null) == null ? {} : rules.value.ratelimit

        content {
          characteristics = lookup(each.value, "characteristics", [
            "cf.colo.id",
            "ip.src"
          ])
          period              = lookup(each.value, "period", 10)
          requests_per_period = lookup(each.value, "requests_per_period", 2000)
          mitigation_timeout  = lookup(each.value, "mitigation_timeout", 10)
          requests_to_origin  = lookup(each.value, "requests_to_origin", false)
        }
      }

      expression  = lookup(rules.value, "expression", "(http.request.uri.path matches \"/*\")") # enterprise only
      description = lookup(rules.value, "description", "Rate limiting rule")
      enabled     = lookup(rules.value, "enabled", true)
    }
  }
}
