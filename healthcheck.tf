locals {
  healthchecks = module.this.enabled && var.healthchecks != null ? {
    for healthcheck in flatten(var.healthchecks) :
    format("%s-%s-%s",
      lookup(healthcheck, "name", null) == null ? module.this.id : healthcheck.name,
      healthcheck.type,
      healthcheck.address
    ) => healthcheck
  } : {}
}

resource "cloudflare_healthcheck" "default" {
  for_each = local.healthchecks

  zone_id                      = local.zone_id
  name                         = lookup(each.value, "name", null) == null ? each.key : each.value.name
  description                  = lookup(each.value, "description", null) == null ? "Managed by Terraform" : each.value.description
  address                      = each.value.address
  suspended                    = lookup(each.value, "suspended", null) == null ? false : each.value.suspended
  check_regions                = lookup(each.value, "check_regions", null)
  notification_suspended       = lookup(each.value, "notification_suspended", null) == null ? false : each.value.notification_suspended
  notification_email_addresses = lookup(each.value, "notification_email_addresses", null)
  type                         = each.value.type
  port                         = lookup(each.value, "suspended", null) == null ? 80 : each.value.port
  timeout                      = lookup(each.value, "timeout", null) == null ? 5 : each.value.timeout
  retries                      = lookup(each.value, "retries", null) == null ? 3 : each.value.retries
  interval                     = lookup(each.value, "interval", null) == null ? 60 : each.value.interval
  consecutive_fails            = lookup(each.value, "consecutive_fails", null) == null ? 1 : each.value.consecutive_fails
  consecutive_successes        = lookup(each.value, "consecutive_successes", null) == null ? 1 : each.value.consecutive_successes
  method                       = lookup(each.value, "method", null) == null ? (each.value.type == "TCP" ? "connection_established" : "GET") : each.value.method
  path                         = lookup(each.value, "path", null) == null ? (each.value.type == "TCP" ? null : "/") : each.value.path
  expected_body                = lookup(each.value, "expected_body", null)
  expected_codes               = lookup(each.value, "expected_codes", null) == null ? (each.value.type == "TCP" ? null : ["200"]) : each.value.expected_codes
  follow_redirects             = lookup(each.value, "follow_redirects", null) == null ? (each.value.type == "TCP" ? null : false) : each.value.follow_redirects
  allow_insecure               = lookup(each.value, "allow_insecure", null) == null ? (each.value.type == "HTTPS" ? false : null) : each.value.allow_insecure

  dynamic "header" {
    for_each = lookup(each.value, "header", null) == null ? [] : [lookup(each.value, "header", {})]
    content {
      header = header.value.header
      values = header.value.values
    }
  }
}
