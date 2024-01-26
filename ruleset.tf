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
        for_each = lookup(rules.value, "action_parameters", null) == null ? [] : [lookup(rules.value, "action_parameters", {})]

        content {
          id                         = lookup(action_parameters.value, "id", null)
          origin_error_page_passthru = lookup(action_parameters.value, "origin_error_page_passthru", null)
          dynamic "headers" {
            for_each = lookup(action_parameters.value, "headers", null) == null ? [] : [lookup(action_parameters.value, "headers", {})]

            content {
              name      = lookup(headers.value, "name", null)
              operation = lookup(headers.value, "operation", null)
              value     = lookup(headers.value, "value", null)
            }
          }
          dynamic "from_value" {
            for_each = lookup(action_parameters.value, "from_value", null) == null ? [] : [lookup(action_parameters.value, "from_value", {})]

            content {
              status_code = lookup(from_value.value, "status_code", null)
              dynamic "target_url" {
                for_each = lookup(from_value.value, "target_url", [])
                content {
                  value = lookup(target_url.value, "value", null)
                }
              }
              preserve_query_string = lookup(from_value.value, "preserve_query_string", null)
            }
          }
          dynamic "overrides" {
            for_each = lookup(action_parameters.value, "overrides", null) == null ? [] : [lookup(action_parameters.value, "overrides", {})]

            content {
              dynamic "rules" {
                for_each = lookup(overrides.value, "rules", [])
                content {
                  id                = lookup(rules.value, "id", null)
                  sensitivity_level = lookup(rules.value, "sensitivity_level", null)
                }
              }
            }
          }
        }
      }

      expression  = lookup(rules.value, "expression", null)
      description = lookup(rules.value, "description", null)
      enabled     = lookup(rules.value, "enabled", null)
    }
  }
}
