module "zone" {
  source = "../.."

  account_id   = var.account_id
  zone         = var.zone
  zone_enabled = false
  argo_enabled = false

  records = [
    {
      name = "@"
      value = "FOO"
      type = "TXT"
      ttl = 300
      proxied = false
    },
    {
      name = "@"
      value = "BAR"
      type = "TXT"
      ttl = 300
      proxied = false
    },
    {
      name  = format("bastion-%s", join("", var.attributes))
      value = "1.1.1.1"
      type  = "A"
      ttl   = 1
    },
    {
      name  = format("api-%s", join("", var.attributes))
      value = "1.1.1.1"
      type  = "A"
      ttl   = 1
    }
  ]

  firewall_rules = [
    {
      expression  = "(ip.src eq 192.168.0.1)"
      description = "Block access from 192.168.0.1"
      action      = "block"
    }
  ]

  healthchecks = [
    {
      address = format("bastion-%s.%s", join("", var.attributes), var.zone)
      check_regions = [
        "WEU",
        "EEU"
      ]
      type                  = "TCP"
      port                  = "22"
      timeout               = 10
      retries               = 2
      interval              = 60
      consecutive_fails     = 3
      consecutive_successes = 2
      suspended             = true
    },
    {
      address = format("api-%s.%s", join("", var.attributes), var.zone)
      check_regions = [
        "WEU",
        "EEU"
      ]
      type                  = "HTTPS"
      port                  = "443"
      timeout               = 10
      retries               = 2
      interval              = 60
      consecutive_fails     = 3
      consecutive_successes = 2
      suspended             = true
    }
  ]

  page_rules = [
    {
      target = format("api-%s.%s/v1/*", join("", var.attributes), var.zone)
      actions = {

        forwarding_url = {
          url         = format("https://www.api-%s.%s/$1", join("", var.attributes), var.zone)
          status_code = "301"
        }
      }
    }
  ]

  context = module.this.context
}
