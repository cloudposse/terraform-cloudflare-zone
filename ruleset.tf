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
      ratelimit {
        characteristics     = []
        period              = lookup(each.value, "period", 10)
        requests_per_period = lookup(each.value, "requests_per_period", 2000)
        mitigation_timeout  = lookup(each.value, "mitigation_timeout", 10)
        requests_to_origin  = false
      }
      expression  = "(http.request.uri.path matches \"/*\")"
      description = "Rate limiting rule"
      enabled     = true
    }
  }
}
