locals {
  load_balancer = { for lb in var.load_balancer : lb.name => lb }
}
resource "cloudflare_load_balancer" "default" {
  for_each = local.load_balancer

  zone_id = local.zone_id
  name    = lookup(each.value, "name", null) == null ? each.key : each.value.name

  fallback_pool_id = cloudflare_load_balancer_pool.default.id
  default_pool_ids = [cloudflare_load_balancer_pool.default.id]

  description     = lookup(each.value, "description", "load balancer using geo-balancing")
  proxied         = true
  steering_policy = "geo"

  dynamic "rules" {
    for_each = lookup(each.value, "rules", [])

    content {
      name = lookup(each.value, "name", "default rule")
      fixed_response {
        message_body = "hello"
        status_code  = 200
        content_type = "html"
        location     = "www.example.com"
      }
      condition = "" # An empty condition is always true
    }
  }
}

resource "cloudflare_load_balancer_pool" "default" {
  for_each = local.load_balancer

  account_id         = var.account_id
  name               = each.value.name
  latitude           = each.value.latitude
  longitude          = each.value.longitude
  description        = each.value.description
  enabled            = each.value.enabled
  minimum_origins    = each.value.min_origins
  notification_email = each.value.email

  load_shedding {
    default_percent = each.value.load_shedding.default_percent
    default_policy  = each.value.load_shedding.default_policy
    session_percent = each.value.load_shedding.session_percent
    session_policy  = each.value.load_shedding.session_policy
  }

  origin_steering {
    policy = each.value.steering.policy
  }

  dynamic "origins" {
    for_each = each.value.origin_configs

    content {
      name    = origins.value.name
      address = origins.value.address
      enabled = origins.value.enabled

      dynamic "header" {
        for_each = [origins.value.header]

        content {
          header = header.key
          values = header.value
        }
      }
    }
  }
}
