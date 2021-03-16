resource "cloudflare_filter" "default" {
  for_each    = var.filters # list of filters with additional `action` files for cloudflare_firewall_rule
  zone_id     = join("", cloudflare_zone.default.*.id)
  description = "Wordpress break-in attempts that are outside of the office"
  expression  = "(http.request.uri.path ~ \".*wp-login.php\" or http.request.uri.path ~ \".*xmlrpc.php\") and ip.src ne 192.0.2.1"
}

resource "cloudflare_firewall_rule" "default" {
  for_each = {
    for filter in cloudflare_filter.default :
    filter.id => filter.something
  }
  zone_id     = join("", cloudflare_zone.default.*.id)
  description = "Block wordpress break-in attempts"
  filter_id   = cloudflare_filter.wordpress.id
  action      = "block"
}
