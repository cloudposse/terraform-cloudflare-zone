output "id" {
  description = "The zone ID."
  value       = join("", cloudflare_zone.default.*.id)
}

output "plan" {
  description = "The name of the commercial plan to apply to the zone."
  value       = join("", cloudflare_zone.default.*.plan)
}

output "vanity_name_servers" {
  description = "A list of Vanity Nameservers."
  value       = try(cloudflare_zone.default.*.vanity_name_servers, null)
}

output "meta_wildcard_proxiable" {
  description = "Indicates whether wildcard DNS records can receive Cloudflare security and performance features."
  value       = join("", cloudflare_zone.default.*.meta.wildcard_proxiable)
}

output "meta_phishing_detected" {
  description = "Indicates if URLs on the zone have been identified as hosting phishing content."
  value       = join("", cloudflare_zone.default.*.meta.phishing_detected)
}

output "status" {
  description = "Status of the zone."
  value       = join("", cloudflare_zone.default.*.status)
}

output "name_servers" {
  description = "A list of Cloudflare-assigned name servers. This is only populated for zones that use Cloudflare DNS."
  value       = try(cloudflare_zone.default.*.name_servers, null)
}

output "verification_key" {
  description = "Contains the TXT record value to validate domain ownership. This is only populated for zones of type `partial`."
  value       = join("", cloudflare_zone.default.*.verification_key)
}
