output "zone_id" {
  description = "The zone ID."
  value       = module.zone.id
}

output "zone_record_hostnames_to_ids" {
  description = "A map of the zone record hostnames to IDs."
  value       = module.zone.record_hostnames_to_ids
}

output "zone_page_rule_targets_to_ids" {
  description = "A map of the page rule targets to IDs."
  value       = module.zone.page_rule_targets_to_ids
}
