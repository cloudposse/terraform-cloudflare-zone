locals {
  load_balancer = { for lb in var.load_balancer : lb.name => lb.pools }
}
resource "cloudflare_load_balancer" "default" {
  for_each = local.load_balancer

  zone_id = local.zone_id
  name    = lookup(each.value, "name", null) == null ? each.key : each.value.name

  fallback_pool_id = cloudflare_load_balancer_pool.default[each.key].id
  default_pool_ids = [for pool in values(cloudflare_load_balancer_pool.default) : pool[each.key].id]

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
  for_each = { for name, lb in local.load_balancer : name => lb }

  account_id         = var.account_id
  name               = each.value.name
  latitude           = each.value.latitude
  longitude          = each.value.longitude
  description        = each.value.description
  enabled            = each.value.enabled
  minimum_origins    = each.value.min_origins
  notification_email = each.value.email

  dynamic "origins" {
    for_each = each.value

    content {
      name    = origins.value.name
      address = origins.value.address
      enabled = origins.value.enabled
    }
  }
}
