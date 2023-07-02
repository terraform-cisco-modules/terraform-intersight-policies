#__________________________________________________________________
#
# Intersight Fibre Channel QoS Policy
# GUI Location: Policies > Create Policy > Fibre Channel QoS
#__________________________________________________________________

resource "intersight_vnic_fc_qos_policy" "fibre_channel_qos" {
  for_each = { for v in lookup(local.policies, "fibre_channel_qos", []) : v.name => v }
  burst    = lookup(each.value, "burst", local.defaults.fibre_channel_qos.burst) # FI-Attached
  cos      = lookup(each.value, "cos", local.defaults.fibre_channel_qos.cos)     # Standalone
  description = lookup(
  each.value, "description", "${local.name_prefix.fibre_channel_qos}${each.key}${local.name_suffix.fibre_channel_qos} Fibre-Channel QoS Policy.")
  max_data_field_size = lookup(
    each.value, "max_data_field_size", local.defaults.fibre_channel_qos.max_data_field_size
  ) # FI-Attached and Standalone
  name = "${local.name_prefix.fibre_channel_qos}${each.key}${local.name_suffix.fibre_channel_qos}"
  rate_limit = lookup(
    each.value, "rate_limit", local.defaults.fibre_channel_qos.rate_limit
  ) # FI-Attached and Standalone
  organization {
    moid        = local.orgs[var.organization]
    object_type = "organization.Organization"
  }
  dynamic "tags" {
    for_each = lookup(each.value, "tags", var.tags)
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
