locals {
  rulesets = module.this.enabled && var.rulesets != null ? {
    for rs in flatten(var.rulesets) :
    rs.target => rs
  } : {}
}

resource "cloudflare_page_rule" "default" {
  for_each = local.rulesets

  kind  = each.value.kind
  name  = each.value.name
  phase = each.value.phase


  account_id                 = lookup(each.value, "account_id", null)
  zone_id                    = lookup(each.value, "zone_id", null)
  description                = lookup(each.value, "description", null)
  shareable_entitlement_name = lookup(each.value, "shareable_entitlement_name", null)

  dynamic "rules" {
    for_each = each.value.rules

    content {

      expression = rules.value.expression

      action      = rules.value.action
      description = rules.value.description
      enabled     = rules.value.enabled

      dynamic "action_parameters" {
        for_each = rules.value.action_parameters

        content {
          browser_ttl                = action_parameters.value.browser_ttl
          cache                      = action_parameters.value.cache
          cache_key                  = action_parameters.value.cache_key
          cookie_fields              = action_parameters.value.cookie_fields
          edge_ttl                   = action_parameters.value.edge_ttl
          from_list                  = action_parameters.value.from_list
          from_value                 = action_parameters.value.from_value
          headers                    = action_parameters.value.headers
          host_header                = action_parameters.value.host_header
          ip                         = action_parameters.value.ip
          increment                  = action_parameters.value.increment
          matched_data               = action_parameters.value.matched_data
          origin                     = action_parameters.value.origin
          origin_error_page_passthru = action_parameters.value.origin_error_page_passthru
          overrides                  = action_parameters.value.overrides
          phases                     = action_parameters.value.phases
          products                   = action_parameters.value.products
          request_fields             = action_parameters.value.request_fields
          respect_strong_etags       = action_parameters.value.respect_strong_etags
          response                   = action_parameters.value.response
          response_fields            = action_parameters.value.response_fields
          rulesets                   = action_parameters.value.rulesets
          serve_stale                = action_parameters.value.serve_stale
          uri                        = action_parameters.value.uri
          version                    = action_parameters.value.version
        }
      }


      dynamic "exposed_credential_check" {
        for_each = rules.value.exposed_credential_check

        content {
          password_expression = exposed_credential_check.value.password_expression
          username_expression = exposed_credential_check.value.username_expression
        }
      }

      dynamic "logging" {
        for_each = rules.value.logging

        content {
          enabled = logging.value.enabled
          status  = logging.value.status
        }
      }

      dynamic "ratelimit" {
        for_each = rules.value.ratelimit

        content {
          characteristics     = ratelimit.value.characteristics
          counting_expression = ratelimit.value.counting_expression
          mitigation_timeout  = ratelimit.value.mitigation_timeout
          period              = ratelimit.value.period
          requests_per_period = ratelimit.value.requests_per_period
          requests_to_origin  = ratelimit.value.requests_to_origin
        }
      }
    }
  }
}
