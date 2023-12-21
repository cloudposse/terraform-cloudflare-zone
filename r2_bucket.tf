# locals {
#   r2_bucket = module.this.enabled && var.r2_bucket != null ? {
#     for sett in flatten(var.r2_bucket) :
#     local.zone_id => sett
#   } : {}
# }

# resource "cloudflare_r2_bucket" "this" {
#   for_each = local.r2_bucket

#   zone_id = local.zone_id

#   name     = lookup(each.value, "name", "off")
#   location = lookup(each.value, "location", "eeur")
# }
