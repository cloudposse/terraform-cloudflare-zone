<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | >= 2.19 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | >= 2.19 |
| <a name="provider_time"></a> [time](#provider\_time) | >= 0.7 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.24.1 |

## Resources

| Name | Type |
|------|------|
| [cloudflare_argo.default](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/argo) | resource |
| [cloudflare_filter.default](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/filter) | resource |
| [cloudflare_firewall_rule.default](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/firewall_rule) | resource |
| [cloudflare_healthcheck.default](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/healthcheck) | resource |
| [cloudflare_page_rule.default](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/page_rule) | resource |
| [cloudflare_record.default](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) | resource |
| [cloudflare_zone.default](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zone) | resource |
| [time_sleep.wait_for_records_creation](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [cloudflare_zones.default](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/data-sources/zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| <a name="input_argo_enabled"></a> [argo\_enabled](#input\_argo\_enabled) | Whether to enable Cloudflare Argo for DNS zone | `bool` | `false` | no |
| <a name="input_argo_smart_routing_enabled"></a> [argo\_smart\_routing\_enabled](#input\_argo\_smart\_routing\_enabled) | Whether smart routing is enabled. | `bool` | `true` | no |
| <a name="input_argo_tiered_caching_enabled"></a> [argo\_tiered\_caching\_enabled](#input\_argo\_tiered\_caching\_enabled) | Whether tiered caching is enabled. | `bool` | `true` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules) | paused:<br>  Whether this filter is currently paused.<br>expression:<br>  The filter expression to be used.<br>description:<br>  A note that you can use to describe the purpose of the filter and rule.<br>ref:<br>  Short reference tag to quickly select related rules.<br>action:<br>  The action to apply to a matched request. <br>  Possible values: `block`, `challenge`, `allow`, `js_challenge`, `bypass`.<br>priority:<br>  The priority of the rule to allow control of processing order. <br>  A lower number indicates high priority.<br>  If not provided, any rules with a priority will be sequenced before those without.<br>products:<br>  List of products to bypass for a request when the bypass action is used. <br>  Possible values: `zoneLockdown`, `uaBlock`, `bic`, `hot`, `securityLevel`, `rateLimit`, `waf`. | `list(any)` | `null` | no |
| <a name="input_healthchecks"></a> [healthchecks](#input\_healthchecks) | A list of maps of Health Checks rules. <br>The values of map is fully compliant with `cloudflare_healthcheck` resource.<br>To get more info see https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/healthcheck | `list(any)` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_jump_start"></a> [jump\_start](#input\_jump\_start) | Whether to scan for DNS records on creation. | `bool` | `false` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | The letter case of output label values (also used in `tags` and `id`).<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| <a name="input_page_rules"></a> [page\_rules](#input\_page\_rules) | A list of maps of Page Rules. <br>The values of map is fully compliant with `cloudflare_page_rule` resource.<br>To get more info see https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/cloudflare_page_rule | `list(any)` | `null` | no |
| <a name="input_paused"></a> [paused](#input\_paused) | Whether this zone is paused (traffic bypasses Cloudflare) | `bool` | `false` | no |
| <a name="input_plan"></a> [plan](#input\_plan) | The name of the commercial plan to apply to the zone. Possible values: `free`, `pro`, `business`, `enterprise` | `string` | `"free"` | no |
| <a name="input_records"></a> [records](#input\_records) | name:<br>  The name of the record.<br>type:<br>  The type of the record.<br>value:<br>  The value of the record.<br>ttl:<br>  The TTL of the record.<br>  Default value: 1.<br>priority:<br>  The priority of the record. <br>proxied:<br>  Whether the record gets Cloudflare's origin protection. <br>  Default value: false. | `list(any)` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| <a name="input_type"></a> [type](#input\_type) | A full zone implies that DNS is hosted with Cloudflare. A `partial` zone is typically a partner-hosted zone or a CNAME setup. Possible values: `full`, `partial`. | `string` | `"full"` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | The DNS zone name which will be added. | `string` | n/a | yes |
| <a name="input_zone_enabled"></a> [zone\_enabled](#input\_zone\_enabled) | Whether to create DNS zone otherwise use existing. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_filter_ids"></a> [filter\_ids](#output\_filter\_ids) | A list of filter IDs. |
| <a name="output_firewall_rule_ids"></a> [firewall\_rule\_ids](#output\_firewall\_rule\_ids) | A list of firewall rule IDs. |
| <a name="output_id"></a> [id](#output\_id) | The zone ID. |
| <a name="output_meta_phishing_detected"></a> [meta\_phishing\_detected](#output\_meta\_phishing\_detected) | Indicates if URLs on the zone have been identified as hosting phishing content. |
| <a name="output_meta_wildcard_proxiable"></a> [meta\_wildcard\_proxiable](#output\_meta\_wildcard\_proxiable) | Indicates whether wildcard DNS records can receive Cloudflare security and performance features. |
| <a name="output_name_servers"></a> [name\_servers](#output\_name\_servers) | A list of Cloudflare-assigned name servers. This is only populated for zones that use Cloudflare DNS. |
| <a name="output_page_rule_targets_to_ids"></a> [page\_rule\_targets\_to\_ids](#output\_page\_rule\_targets\_to\_ids) | A map of the page rule targets to IDs. |
| <a name="output_plan"></a> [plan](#output\_plan) | The name of the commercial plan to apply to the zone. |
| <a name="output_record_hostnames_to_ids"></a> [record\_hostnames\_to\_ids](#output\_record\_hostnames\_to\_ids) | A map of the zone record hostnames to IDs. |
| <a name="output_status"></a> [status](#output\_status) | Status of the zone. |
| <a name="output_vanity_name_servers"></a> [vanity\_name\_servers](#output\_vanity\_name\_servers) | A list of Vanity Nameservers. |
| <a name="output_verification_key"></a> [verification\_key](#output\_verification\_key) | Contains the TXT record value to validate domain ownership. This is only populated for zones of type `partial`. |
<!-- markdownlint-restore -->
