output "zone_id" {
  description = "The zone ID."
  value       = module.zone.id
}

output "zone_record_hostnames_to_ids" {
  description = "A map of the zone record hostnames to IDs."
  value       = module.zone.record_hostnames_to_ids
}

output "zone_filter_ids" {
  description = "A list of filter IDs."
  value       = module.zone.filter_ids
}

output "zone_firewall_rule_ids" {
  description = "A list of firewall rule IDs."
  value       = module.zone.firewall_rule_ids
}
