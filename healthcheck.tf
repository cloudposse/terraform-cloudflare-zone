resource "cloudflare_healthcheck" "default" {
  for_each = var.healthchecks_list

  zone_id = join("", cloudflare_zone.default.*.id)

  ## billion lookups here 
  name        = "tcp-health-check"
  description = "example tcp health check"
  address     = "example.com"
  suspended   = false
  check_regions = [
    "WEU",
    "EEU"
  ]
  notification_suspended = false
  notification_email_addresses = [
    "hostmaster@example.com"
  ]
  type                  = "TCP"
  port                  = "22"
  method                = "connection_established"
  timeout               = 10
  retries               = 2
  interval              = 60
  consecutive_fails     = 3
  consecutive_successes = 2
}
