locals {
  load_balancers = { for lb in var.load_balancers : lb.name => lb }
  lb_pools = toset(flatten([
    for lb in local.load_balancers :
    [
      for pool in lb.pools : {
        name    = pool.name
        lb_name = lb.name
        enabled = pool.enabled
        origins = pool.origins
      }
    ]
  ]))
  lb_monitors = toset(flatten([
    for lb in local.load_balancers :
    [
      for monitor in lb.monitors : {
        lb_name        = lb.name
        type           = monitor.type
        expected_codes = monitor.expected_codes
        method         = monitor.method
        timeout        = monitor.timeout
        path           = monitor.path
        interval       = monitor.interval
        retries        = monitor.retries
        description    = monitor.description
      }
    ]
  ]))
}

# resource "cloudflare_load_balancer" "default" {
#   for_each = local.load_balancers

#   zone_id = local.zone_id
#   name    = lookup(each.value, "name", null) == null ? each.key : each.value.name

#   fallback_pool_id = cloudflare_load_balancer_pool.default["each.key/eu-central-1"].id
#   # default_pool_ids = [for pool in values(cloudflare_load_balancer_pool.default) : pool[each.key].id]
#   default_pool_ids = [for k, v in cloudflare_load_balancer_pool.default : k => v.id]

#   description     = lookup(each.value, "description", "load balancer using geo-balancing")
#   proxied         = true
#   steering_policy = "dynamic_latency"
# }

resource "cloudflare_load_balancer_pool" "default" {
  for_each = {
    for pool in local.lb_pools : "${pool.lb_name}/${pool.name}" => pool
  }

  account_id         = var.account_id
  name               = lookup(each.value, "name", null)
  latitude           = lookup(each.value, "latitude", null)
  longitude          = lookup(each.value, "longitude", null)
  description        = lookup(each.value, "description", null)
  enabled            = lookup(each.value, "enabled", null)
  minimum_origins    = lookup(each.value, "minimum_origins", null)
  notification_email = lookup(each.value, "notification_email", null)
  monitor            = cloudflare_load_balancer_monitor.default["${plookup(each.value, "lb_name", null)}/${plookup(each.value, "name", null)}"].id

  dynamic "origins" {
    for_each = lookup(each.value, "origins", [])

    content {
      name    = lookup(origins.value, "name", null)
      address = lookup(origins.value, "address", null)
      enabled = lookup(origins.value, "enabled", null)
    }
  }
}

resource "cloudflare_load_balancer_monitor" "default" {
  for_each = {
    for monitor in local.lb_monitors : "${monitor.lb_name}/${monitor.name}" => monitor
  }
  account_id     = var.account_id
  type           = lookup(each.value, "type", null)
  expected_body  = lookup(each.value, "expected_body", null)
  expected_codes = lookup(each.value, "expected_codes", null)
  method         = lookup(each.value, "method", null)
  timeout        = lookup(each.value, "timeout", null)
  path           = lookup(each.value, "path", null)
  interval       = lookup(each.value, "interval", null)
  retries        = lookup(each.value, "retries", null)
  description    = lookup(each.value, "description", null)

  allow_insecure   = lookup(each.value, "allow_insecure", null)
  follow_redirects = lookup(each.value, "follow_redirects", null)
  probe_zone       = lookup(each.value, "probe_zone", null)
}
