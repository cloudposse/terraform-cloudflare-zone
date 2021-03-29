locals {
  page_rules = module.this.enabled && var.page_rules != null ? {
    for pr in flatten(var.page_rules) :
    pr.target => pr
  } : {}
}

resource "cloudflare_page_rule" "default" {
  for_each = local.page_rules

  zone_id  = local.zone_id
  target   = each.value.target
  priority = lookup(each.value, "priority", null)
  status   = lookup(each.value, "status", null)

  actions {
    always_online            = lookup(each.value.actions, "always_online", null)
    always_use_https         = lookup(each.value.actions, "always_use_https", null)
    automatic_https_rewrites = lookup(each.value.actions, "automatic_https_rewrites", null)
    browser_cache_ttl        = lookup(each.value.actions, "browser_cache_ttl", null)
    browser_check            = lookup(each.value.actions, "browser_check", null)
    bypass_cache_on_cookie   = lookup(each.value.actions, "bypass_cache_on_cookie", null)
    cache_by_device_type     = lookup(each.value.actions, "cache_by_device_type", null)
    cache_deception_armor    = lookup(each.value.actions, "cache_deception_armor", null)
    cache_level              = lookup(each.value.actions, "cache_level", null)
    cache_on_cookie          = lookup(each.value.actions, "cache_on_cookie", null)
    ## OBJECT cache_key_fields
    disable_apps                = lookup(each.value.actions, "cache_on_cookie", false)
    disable_performance         = lookup(each.value.actions, "disable_performance", false)
    disable_railgun             = lookup(each.value.actions, "disable_railgun", false)
    disable_security            = lookup(each.value.actions, "disable_security", false)
    edge_cache_ttl              = lookup(each.value.actions, "edge_cache_ttl", null)
    email_obfuscation           = lookup(each.value.actions, "email_obfuscation", null)
    host_header_override        = lookup(each.value.actions, "host_header_override", null)
    ip_geolocation              = lookup(each.value.actions, "ip_geolocation", null)
    mirage                      = lookup(each.value.actions, "mirage", null)
    opportunistic_encryption    = lookup(each.value.actions, "opportunistic_encryption", null)
    origin_error_page_pass_thru = lookup(each.value.actions, "origin_error_page_pass_thru", null)
    polish                      = lookup(each.value.actions, "polish", null)
    resolve_override            = lookup(each.value.actions, "resolve_override", null)
    respect_strong_etag         = lookup(each.value.actions, "respect_strong_etag", null)
    response_buffering          = lookup(each.value.actions, "response_buffering", null)
    rocket_loader               = lookup(each.value.actions, "rocket_loader", null)
    security_level              = lookup(each.value.actions, "security_level", null)
    server_side_exclude         = lookup(each.value.actions, "server_side_exclude", null)
    sort_query_string_for_cache = lookup(each.value.actions, "sort_query_string_for_cache", null)
    ssl                         = lookup(each.value.actions, "ssl", null)
    true_client_ip_header       = lookup(each.value.actions, "true_client_ip_header", null)
    waf                         = lookup(each.value.actions, "waf", null)

    dynamic "cache_ttl_by_status" {
      for_each = lookup(each.value.actions, "cache_ttl_by_status", null) == null ? {} : {
        for ctbs in each.value.actions.cache_ttl_by_status :
        ctbs.codes => ctbs
      }

      content {
        codes = cache_ttl_by_status.value.codes
        ttl   = cache_ttl_by_status.value.ttl
      }
    }

    dynamic "forwarding_url" {
      for_each = lookup(each.value.actions, "forwarding_url", null) == null ? [] : [each.value.actions.forwarding_url]

      content {
        url         = forwarding_url.value.url
        status_code = forwarding_url.value.status_code
      }
    }
    dynamic "minify" {
      for_each = lookup(each.value.actions, "minify", null) == null ? [] : [each.value.actions.minify]

      content {
        html = lookup(minify.value, "html", null)
        css  = lookup(minify.value, "css", null)
        js   = lookup(minify.value, "js", null)
      }
    }

    dynamic "cache_key_fields" {
      for_each = lookup(each.value.actions, "cache_key_fields", null) == null ? [] : [each.value.actions.cache_key_fields]

      content {
        cookie {
          check_presence = lookup(cache_key_fields.value.cookie, "check_presence", null)
          include        = lookup(cache_key_fields.value.cookie, "include", null)
        }

        header {
          check_presence = lookup(cache_key_fields.value.header, "check_presence", null)
          exclude        = lookup(cache_key_fields.value.header, "exclude", null)
          include        = lookup(cache_key_fields.value.header, "include", null)
        }

        host {
          resolved = lookup(cache_key_fields.value.host, "resolved", null)
        }

        query_string {
          exclude = lookup(cache_key_fields.value.query_string, "exclude", null)
          include = lookup(cache_key_fields.value.query_string, "include", null)
          ignore  = lookup(cache_key_fields.value.query_string, "ignore", null)
        }
        user {
          device_type = lookup(cache_key_fields.value.user, "device_type", null)
          geo         = lookup(cache_key_fields.value.user, "geo", null)
          lang        = lookup(cache_key_fields.value.user, "lang", null)
        }
      }
    }
  }

  depends_on = [
    cloudflare_record.default
  ]
}
