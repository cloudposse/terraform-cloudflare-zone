locals {
  load_balancers = module.this.enabled && var.healthchecks != null ? var.load_balancers : null
  lb_pools = module.this.enabled && local.load_balancers != null ? toset(flatten([
    for lb_name, lb in var.load_balancers : [
      for pool_name, pool in lb : {
        name               = pool_name
        lb_name            = lb_name
        enabled            = lookup(pool, "enabled", null)
        latitude           = lookup(pool, "latitude", null)
        longitude          = lookup(pool, "longitude", null)
        description        = lookup(pool, "description", null)
        minimum_origins    = lookup(pool, "minimum_origins", null)
        notification_email = lookup(pool, "notification_email", null)
        origins            = lookup(pool, "origins", {})
      }
    ]
  ])) : {}
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

  dynamic "origins" {
    for_each = lookup(each.value, "origins", {})

    content {
      name    = lookup(origins.value, "name", null)
      address = lookup(origins.value, "address", null)
      enabled = lookup(origins.value, "enabled", null)
    }
  }
}
