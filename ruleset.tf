locals {
  rulesets = module.this.enabled && var.rulesets != null ? {
    for rs in flatten(var.rulesets) :
    format("%s-%s",
      rs.kind,
      md5(rule.name),
    ) => rs
  } : {}
}

resource "cloudflare_ruleset" "default" {
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
      expression  = rules.value.expression
      action      = rules.value.action
      description = rules.value.description
      enabled     = rules.value.enabled

      dynamic "action_parameters" {
        for_each = rules.value.action_parameters

        content {
          dynamic "browser_ttl" {
            for_each = action_parameters.value.browser_ttl

            content {
              mode    = browser_ttl.value.mode
              default = browser_ttl.value.default
            }
          }

          dynamic "cache_key" {
            for_each = action_parameters.value.cache_key

            content {
              cache_by_device_type  = cache_key.value.cache_by_device_type
              cache_deception_armor = cache_key.value.cache_deception_armor

              dynamic "custom_key" {
                for_each = cache_key.value.custom_key
                content {
                  dynamic "cookie" {
                    for_each = custom_key.value.cookie

                    content {
                      check_presence = cookie.value.check_presence
                      include        = cookie.value.include
                    }
                  }

                  dynamic "header" {
                    for_each = custom_key.value.header

                    content {
                      check_presence = header.value.check_presence
                      exclude_origin = header.value.exclude_origin
                      include        = header.value.include
                    }
                  }

                  dynamic "host" {
                    for_each = custom_key.value.host

                    content {
                      resolved = host.value.resolved
                    }
                  }

                  dynamic "query_string" {
                    for_each = custom_key.value.query_string

                    content {
                      exclude = query_string.value.exclude
                      include = query_string.value.include
                    }
                  }

                  dynamic "user" {
                    for_each = custom_key.value.user

                    content {
                      device_type = user.value.device_type
                      geo         = user.value.geo
                      lang        = user.value.lang
                    }
                  }
                }
              }
              ignore_query_strings_order = cache_key.value.ignore_query_strings_order
            }
          }

          dynamic "edge_ttl" {
            for_each = action_parameters.value.edge_ttl

            content {
              default = edge_ttl.value.default
              mode    = edge_ttl.value.mode

              dynamic "status_code_ttl" {
                for_each = edge_ttl.value.status_code_ttl

                content {
                  value       = status_code_ttl.value.value
                  status_code = status_code_ttl.value.status_code

                  dynamic "status_code_range" {
                    for_each = status_code_ttl.value.status_code_range

                    content {
                      from = status_code_range.value.from
                      to   = status_code_range.value.to
                    }
                  }
                }
              }
            }
          }

          dynamic "from_list" {
            for_each = action_parameters.value.from_list

            content {
              key  = from_list.value.key
              name = from_list.value.name
            }
          }

          dynamic "from_value" {
            for_each = action_parameters.value.from_value

            content {
              preserve_query_string = from_value.value.preserve_query_string
              status_code           = from_value.value.status_code

              dynamic "target_url" {
                for_each = from_value.value.target_url

                content {
                  expression = target_url.value.expression
                  value      = target_url.value.value
                }
              }
            }
          }

          dynamic "headers" {
            for_each = action_parameters.value.headers

            content {
              expression = headers.value.expression
              name       = headers.value.name
              operation  = headers.value.operation
              value      = headers.value.value
            }
          }

          dynamic "matched_data" {
            for_each = action_parameters.value.matched_data

            content {
              public_key = matched_data.value.public_key
            }
          }

          dynamic "origin" {
            for_each = action_parameters.value.origin

            content {
              host = origin.value.host
              port = origin.value.port
            }
          }

          dynamic "overrides" {
            for_each = action_parameters.value.overrides

            content {
              action  = overrides.value.action
              enabled = overrides.value.enabled
              status  = overrides.value.status

              dynamic "categories" {
                for_each = overrides.value.categories

                content {
                  action   = categories.value.action
                  category = categories.value.category
                  enabled  = categories.value.enabled
                  status   = categories.value.status
                }
              }

              dynamic "rules" {
                for_each = overrides.value.rules

                content {
                  action            = rules.value.action
                  enabled           = rules.value.enabled
                  id                = rules.value.id
                  score_threshold   = rules.value.score_threshold
                  sensitivity_level = rules.value.sensitivity_level
                  status            = rules.value.status
                }
              }
            }
          }

          dynamic "response" {
            for_each = action_parameters.value.response

            content {
              content      = response.value.content
              content_type = response.value.content_type
              status_code  = response.value.status_code
            }
          }

          dynamic "serve_stale" {
            for_each = action_parameters.value.serve_stale

            content {
              disable_stale_while_updating = serve_stale.value.disable_stale_while_updating
            }
          }

          dynamic "uri" {
            for_each = action_parameters.value.uri

            content {
              origin = uri.value.origin

              dynamic "path" {
                for_each = uri.value.path

                content {
                  expression = uri.value.expression
                  value      = uri.value.value
                }
              }

              dynamic "query" {
                for_each = uri.value.query

                content {
                  expression = query.value.expression
                  value      = query.value.value
                }
              }
            }
          }

          cache                      = action_parameters.value.cache
          cookie_fields              = action_parameters.value.cookie_fields
          host_header                = action_parameters.value.host_header
          id                         = action_parameters.value.id
          increment                  = action_parameters.value.increment
          origin_error_page_passthru = action_parameters.value.origin_error_page_passthru
          phases                     = action_parameters.value.phases
          products                   = action_parameters.value.products
          request_fields             = action_parameters.value.request_fields
          respect_strong_etags       = action_parameters.value.respect_strong_etags
          response_fields            = action_parameters.value.response_fields
          rules                      = action_parameters.value.rules
          ruleset                    = action_parameters.value.ruleset
          rulesets                   = action_parameters.value.rulesets
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
