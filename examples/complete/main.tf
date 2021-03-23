module "zone" {
  source = "../.."

  zone         = var.zone
  zone_enabled = false
  argo_enabled = false

  records = [
    {
      name  = format("bastion-%s", join("", var.attributes))
      value = "192.168.1.11"
      type  = "A"
      ttl   = 3600
    },
    {
      name  = format("api-%s", join("", var.attributes))
      value = "192.168.2.22"
      type  = "A"
      ttl   = 3600
    }
  ]


  firewall_rules = [
    {
      expression  = "(ip.src eq 192.168.0.1)"
      description = "Block access from 192.168.0.1"
      action      = "block"
    }
  ]

  # looks like domain should be real
  # Error: hostname resolution failed
  #   on ../../healthcheck.tf line 12, in resource "cloudflare_healthcheck" "default":
  #   12: resource "cloudflare_healthcheck" "default" {

  # healthchecks = [
  #   {
  #     address = format("bastion-%s.%s", join("", var.attributes), var.zone)
  #     check_regions = [
  #       "WEU",
  #       "EEU"
  #     ]
  #     notification_email_addresses = [
  #       "hostmaster@cloudposse.com"
  #     ]
  #     type                  = "TCP"
  #     port                  = "22"
  #     timeout               = 10
  #     retries               = 2
  #     interval              = 60
  #     consecutive_fails     = 3
  #     consecutive_successes = 2
  #     suspended             = true
  #   },
  #   {
  #     address = format("api-%s.%s", join("", var.attributes), var.zone)
  #     check_regions = [
  #       "WEU",
  #       "EEU"
  #     ]
  #     notification_email_addresses = [
  #       "hostmaster@cloudposse.com"
  #     ]
  #     type                  = "HTTPS"
  #     port                  = "443"
  #     timeout               = 10
  #     retries               = 2
  #     interval              = 60
  #     consecutive_fails     = 3
  #     consecutive_successes = 2
  #     suspended             = true
  #   }
  # ]
  context = module.this.context
}
