locals {
  cloudflare_lists = module.this.enabled && var.cloudflare_lists != null ? {
    for idx, list_config in flatten(var.cloudflare_lists) :
    lidx => list_config
  } : {}
}

resource "cloudflare_list" "this" {
  for_each = local.cloudflare_lists

  account_id  = var.account_id
  name        = each.value.name
  description = each.value.description
  kind        = each.value.kind

  dynamic "item" {
    for_each = each.value.items
    content {
      value {
        ip = lookup(item.value.value, "ip", null)
        dynamic "redirect" {
          for_each = lookup(item.value.value, "redirect", {})
          content {
            source_url            = redirect.value.source_url
            target_url            = redirect.value.target_url
            include_subdomains    = redirect.value.include_subdomains
            subpath_matching      = redirect.value.subpath_matching
            status_code           = redirect.value.status_code
            preserve_query_string = redirect.value.preserve_query_string
            preserve_path_suffix  = redirect.value.preserve_path_suffix
          }
        }

        dynamic "hostname" {
          for_each = lookup(item.value.value, "hostname", {})
          content {
            url_hostname = hostname.value.url_hostname
          }
        }
        asn = lookup(item.value.value, "asn", null)
      }
      comment = item.value.comment
    }
  }
}

