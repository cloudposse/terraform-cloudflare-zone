locals {
  load_balancers = { for lb in var.load_balancers : lb.name => lb }
  lb_pools = toset(flatten([
    for lb in local.load_balancers :
    [
      for pool in lb.pools : {
        name    = pool.name
        lb_name = lb.name
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

# resource "cloudflare_load_balancer_pool" "default" {
#   for_each = { for pool in local.load_balancers : pool.pools }

#   account_id         = var.account_id
#   name               = lookup(each.value, "name", null)
#   latitude           = lookup(each.value, "latitude", null)
#   longitude          = lookup(each.value, "longitude", null)
#   description        = lookup(each.value, "description", null)
#   enabled            = lookup(each.value, "enabled", null)
#   minimum_origins    = lookup(each.value, "minimum_origins", null)
#   notification_email = lookup(each.value, "notification_email", null)

#   dynamic "origins" {
#     for_each = lookup(each.value, "origins", {})

#     content {
#       name    = lookup(origins.value, "name", null)
#       address = lookup(origins.value, "address", null)
#       enabled = lookup(origins.value, "enabled", null)
#     }
#   }
# }
