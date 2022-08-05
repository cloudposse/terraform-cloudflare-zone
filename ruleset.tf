locals {
  rulesets = { for rs in var.rulesets : rs.name => rs }
}

resource "cloudflare_ruleset" "this" {
  for_each = local.rulesets

  kind  = each.value.kind
  name  = each.value.name
  phase = each.value.phase

  account_id                 = lookup(each.value, "account_id", null)
  zone_id                    = lookup(each.value, "zone_id", null)
  description                = lookup(each.value, "description", null)
  shareable_entitlement_name = lookup(each.value, "shareable_entitlement_name", null)

  dynamic "rules" {
    for_each = lookup(each.value, "rules", [])

    content {
      expression = rules.value.expression
      action     = lookup(rules.value, "action", null)
      # description = rules.value.description
      enabled = lookup(rules.value, "enabled", null)

      dynamic "action_parameters" {
        for_each = lookup(rules.value, "action_parameters", {})

        content {
          dynamic "browser_ttl" {
            for_each = lookup(action_parameters.value, "browser_ttl", {})

            content {
              mode    = browser_ttl.value.mode
              default = lookup(browser_ttl.value, "default", null)
            }
          }

          dynamic "cache_key" {
            for_each = lookup(action_parameters.value, "cache_key", null)

            content {
              cache_by_device_type  = lookup(cache_key.value, "cache_by_device_type", null)
              cache_deception_armor = lookup(cache_key.value, "cache_deception_armor", null)

              dynamic "custom_key" {
                for_each = lookup(cache_key.value, "custom_key", null)
                content {
                  dynamic "cookie" {
                    for_each = lookup(custom_key.value, "cookie", null)

                    content {
                      check_presence = lookup(cookie.value, "check_presence", null)
                      include        = lookup(cookie.value, "include", null)
                    }
                  }

                  dynamic "header" {
                    for_each = lookup(custom_key.value, "header", null)

                    content {
                      check_presence = lookup(header.value, "check_presence", null)
                      exclude_origin = lookup(header.value, "exclude_origin", null)
                      include        = lookup(header.value, "include", null)
                    }
                  }

                  dynamic "host" {
                    for_each = lookup(custom_key.value, "host", null)

                    content {
                      resolved = lookup(host.value, "resolved", null)
                    }
                  }

                  dynamic "query_string" {
                    for_each = lookup(custom_key.value, "query_string", null)

                    content {
                      exclude = lookup(query_string.value, "exclude", null)
                      include = lookup(query_string.value, "include", null)
                    }
                  }

                  dynamic "user" {
                    for_each = lookup(custom_key.value, "user", null)

                    content {
                      device_type = lookup(user.value, "device_type", null)
                      geo         = lookup(user.value, "geo", null)
                      lang        = lookup(user.value, "lang", null)
                    }
                  }
                }
              }
              ignore_query_strings_order = lookup(cache_key.value, "ignore_query_strings_order", null)
            }
          }

          dynamic "edge_ttl" {
            for_each = lookup(action_parameters.value, "edge_ttl", null)

            content {
              default = edge_ttl.value.default
              mode    = edge_ttl.value.mode

              dynamic "status_code_ttl" {
                for_each = lookup(edge_ttl.value, "status_code_ttl", null)

                content {
                  value       = status_code_ttl.value.value
                  status_code = lookup(status_code_ttl.value, "status_code", null)

                  dynamic "status_code_range" {
                    for_each = lookup(status_code_ttl.value, "status_code_range", null)

                    content {
                      from = lookup(status_code_range.value, "from", null)
                      to   = lookup(status_code_range.value, "to", null)
                    }
                  }
                }
              }
            }
          }

          dynamic "from_list" {
            for_each = lookup(action_parameters.value, "from_list", null)

            content {
              key  = lookup(from_list.value, "key", null)
              name = lookup(from_list.value, "name", null)
            }
          }

          dynamic "from_value" {
            for_each = lookup(action_parameters.value, "from_value", null)

            content {
              preserve_query_string = lookup(from_value.value, "preserve_query_string", null)
              status_code           = lookup(from_value.value, "status_code", null)

              dynamic "target_url" {
                for_each = lookup(from_value.value, "target_url", null)

                content {
                  expression = lookup(target_url.value, "expression", null)
                  value      = lookup(target_url.value, "value", null)
                }
              }
            }
          }

          dynamic "headers" {
            for_each = lookup(action_parameters.value, "headers", null)

            content {
              expression = lookup(headers.value, "expression", null)
              name       = lookup(headers.value, "name", null)
              operation  = lookup(headers.value, "operation", null)
              value      = lookup(headers.value, "value", null)
            }
          }

          dynamic "matched_data" {
            for_each = lookup(action_parameters.value, "matched_data", null)

            content {
              public_key = lookup(matched_data.value, "public_key", null)
            }
          }

          dynamic "origin" {
            for_each = lookup(action_parameters.value, "origin", null)

            content {
              host = lookup(origin.value, "host", null)
              port = lookup(origin.value, "port", null)
            }
          }

          dynamic "overrides" {
            for_each = lookup(action_parameters.value, "overrides", null)

            content {
              action  = lookup(overrides.value, "action", null)
              enabled = lookup(overrides.value, "enabled", null)
              status  = lookup(overrides.value, "status", null)

              dynamic "categories" {
                for_each = lookup(overrides.value, "categories", null)

                content {
                  action   = lookup(categories.value, "action", null)
                  category = lookup(categories.value, "category", null)
                  enabled  = lookup(categories.value, "enabled", null)
                  status   = lookup(categories.value, "status", null)
                }
              }

              dynamic "rules" {
                for_each = lookup(overrides.value, "rules", null)

                content {
                  action            = lookup(rules.value, "action", null)
                  enabled           = lookup(rules.value, "enabled", null)
                  id                = lookup(rules.value, "id", null)
                  score_threshold   = lookup(rules.value, "score_threshold", null)
                  sensitivity_level = lookup(rules.value, "sensitivity_level", null)
                  status            = lookup(rules.value, "status", null)
                }
              }
            }
          }

          dynamic "response" {
            for_each = lookup(action_parameters.value, "response", null)

            content {
              content      = lookup(response.value, "content", null)
              content_type = lookup(response.value, "content_type", null)
              status_code  = lookup(response.value, "status_code", null)
            }
          }

          dynamic "serve_stale" {
            for_each = lookup(action_parameters.value, "serve_stale", null)

            content {
              disable_stale_while_updating = lookup(serve_stale.value, "disable_stale_while_updating", null)
            }
          }

          dynamic "uri" {
            for_each = lookup(action_parameters.value, "uri", null)

            content {
              origin = lookup(uri.value, "origin", null)

              dynamic "path" {
                for_each = lookup(uri.value, "path", null)

                content {
                  expression = lookup(uri.value, "expression", null)
                  value      = lookup(uri.value, "value", null)
                }
              }

              dynamic "query" {
                for_each = lookup(uri.value, "query", null)

                content {
                  expression = lookup(query.value, "expression", null)
                  value      = lookup(query.value, "value", null)
                }
              }
            }
          }

          cache                      = lookup(action_parameters.value, "cache", null)
          cookie_fields              = lookup(action_parameters.value, "cookie_fields", null)
          host_header                = lookup(action_parameters.value, "host_header", null)
          id                         = lookup(action_parameters.value, "id", null)
          increment                  = lookup(action_parameters.value, "increment", null)
          origin_error_page_passthru = lookup(action_parameters.value, "origin_error_page_passthru", null)
          phases                     = lookup(action_parameters.value, "phases", null)
          products                   = lookup(action_parameters.value, "products", null)
          request_fields             = lookup(action_parameters.value, "request_fields", null)
          respect_strong_etags       = lookup(action_parameters.value, "respect_strong_etags", null)
          response_fields            = lookup(action_parameters.value, "response_fields", null)
          rules                      = lookup(action_parameters.value, "rules", null)
          ruleset                    = lookup(action_parameters.value, "ruleset", null)
          rulesets                   = lookup(action_parameters.value, "rulesets", null)
          version                    = lookup(action_parameters.value, "version", null)
        }
      }


      dynamic "exposed_credential_check" {
        for_each = lookup(rules.value, "exposed_credential_check", null)

        content {
          password_expression = lookup(exposed_credential_check.value, "password_expression", null)
          username_expression = lookup(exposed_credential_check.value, "username_expression", null)
        }
      }

      dynamic "logging" {
        for_each = lookup(rules.value, "logging")

        content {
          enabled = lookup(logging.value, "enabled", null)
          status  = lookup(logging.value, "status", null)
        }
      }

      dynamic "ratelimit" {
        for_each = lookup(rules.value, "ratelimit", null)

        content {
          characteristics     = lookup(ratelimit.value, "characteristics", null)
          counting_expression = lookup(ratelimit.value, "counting_expression", null)
          mitigation_timeout  = lookup(ratelimit.value, "mitigation_timeout", null)
          period              = lookup(ratelimit.value, "period", null)
          requests_per_period = lookup(ratelimit.value, "requests_per_period", null)
          requests_to_origin  = lookup(ratelimit.value, "requests_to_origin", null)
        }
      }
    }
  }
}
