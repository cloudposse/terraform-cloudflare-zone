locals {
  load_balancers = { for lb in var.load_balancers : lb.name => lb }
  lb_pools = toset(flatten([
    for lb in local.load_balancers :
    [
      for pool in lb.pools : {
        name                   = pool.name
        lb_name                = lb.name
        enabled                = pool.enabled
        origins                = pool.origins
        latitude               = lb.steering_policy == "proximity" ? pool.latitude : null
        longitude              = lb.steering_policy == "proximity" ? pool.longitude : null
        origin_steering_policy = lookup(pool, "origin_steering_policy", "random")
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

resource "cloudflare_load_balancer" "default" {
  for_each = local.load_balancers

  zone_id = local.zone_id
  name    = lookup(each.value, "name", null) == null ? each.key : each.value.name

  fallback_pool_id = cloudflare_load_balancer_pool.default["${lookup(each.value, "name", null)}/${lookup(each.value, "fallback", null)}"].id
  # default_pool_ids = [for pool in values(cloudflare_load_balancer_pool.default) : pool[each.key].id]
  # default_pool_ids = [for k, v in cloudflare_load_balancer_pool.default : v.id]
  default_pool_ids = [
    for pool in values(cloudflare_load_balancer_pool.default) :
    pool.id
    if contains([for p in lookup(each.value, "pools", []) : p.name], pool.name)
  ]

  description          = lookup(each.value, "description", "load balancer using geo-balancing")
  proxied              = true
  steering_policy      = lookup(each.value, "steering_policy", "dynamic_latency")
  session_affinity     = lookup(each.value, "session_affinity", null)
  session_affinity_ttl = lookup(each.value, "session_affinity_ttl", null)

  dynamic "adaptive_routing" {
    for_each = lookup(each.value, "adaptive_routing", null) == null ? [] : [lookup(each.value, "adaptive_routing", {})]

    content {
      failover_across_pools = lookup(adaptive_routing.value, "failover_across_pools", null)
    }
  }
  dynamic "session_affinity_attributes" {
    for_each = lookup(each.value, "session_affinity_attributes", null) == null ? [] : [lookup(each.value, "session_affinity_attributes", {})]

    content {
      drain_duration         = lookup(session_affinity_attributes.value, "drain_duration", null)
      headers                = lookup(session_affinity_attributes.value, "headers", null)
      require_all_headers    = lookup(session_affinity_attributes.value, "require_all_headers", null)
      samesite               = lookup(session_affinity_attributes.value, "samesite", null)
      secure                 = lookup(session_affinity_attributes.value, "secure", null)
      zero_downtime_failover = lookup(session_affinity_attributes.value, "zero_downtime_failover", null)
    }
  }

  dynamic "region_pools" {
    for_each = lookup(each.value, "steering_policy", null) == "geo" ? lookup(each.value, "region_pools", []) : []

    content {
      region   = lookup(region_pools.value, "region", null)
      pool_ids = [for pool in lookup(region_pools.value, "pool_ids", []) : cloudflare_load_balancer_pool.default["${lookup(each.value, "name", null)}/${pool}"].id]
    }
  }
}

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
  monitor            = cloudflare_load_balancer_monitor.default["${lookup(each.value, "lb_name", null)}/${lookup(each.value, "name", null)}"].id

  dynamic "origins" {
    for_each = lookup(each.value, "origins", [])

    content {
      name    = lookup(origins.value, "name", null)
      address = lookup(origins.value, "address", null)
      enabled = lookup(origins.value, "enabled", null)
      weight  = lookup(origins.value, "weight", null)
    }
  }

  origin_steering {
    policy = lookup(each.value, "origin_steering_policy", "random")
  }

}

resource "cloudflare_load_balancer_monitor" "default" {
  for_each = {
    for monitor in local.lb_monitors : "${monitor.lb_name}/${monitor.description}" => monitor
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
