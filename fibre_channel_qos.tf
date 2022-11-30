#__________________________________________________________________
#
# Intersight Fibre Channel QoS Policy
# GUI Location: Policies > Create Policy > Fibre Channel QoS
#__________________________________________________________________

resource "intersight_vnic_fc_qos_policy" "fibre_channel_qos" {
  for_each    = { for v in lookup(local.policies, "fibre_channel_qos", []) : v.name => v }
  burst       = lookup(each.value, "burst", local.defaults.intersight.policies.fibre_channel_qos.burst) # FI-Attached
  cos         = lookup(each.value, "cos", local.defaults.intersight.policies.fibre_channel_qos.cos)     # Standalone
  description = lookup(each.value, "description", "${each.value.name} Fibre-Channel QoS Policy.")
  max_data_field_size = lookup(
    each.value, "max_data_field_size", local.defaults.intersight.policies.fibre_channel_qos.max_data_field_size
  ) # FI-Attached and Standalone
  name = "${each.key}${local.defaults.intersight.policies.fibre_channel_qos.name_suffix}"
  rate_limit = lookup(
    each.value, "rate_limit", local.defaults.intersight.policies.fibre_channel_qos.rate_limit
  ) # FI-Attached and Standalone
  organization {
    moid        = local.orgs[lookup(each.value, "organization", var.organization)]
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
