#__________________________________________________________________
#
# Intersight Fibre Channel QoS Policy
# GUI Location: Policies > Create Policy > Fibre Channel QoS
#__________________________________________________________________

resource "intersight_vnic_fc_qos_policy" "map" {
  for_each = { for v in lookup(local.policies, "fibre_channel_qos", []) : v.name => merge(local.defaults.fibre_channel_qos, v, {
    name = "${local.name_prefix.fibre_channel_qos}${v.name}${local.name_suffix.fibre_channel_qos}"
    tags = lookup(v, "tags", var.tags)
  }) }
  burst               = each.value.burst # FI-Attached
  cos                 = each.value.cos   # Standalone
  description         = coalesce(each.value.description, "${each.value.name} Fibre-Channel QoS Policy.")
  max_data_field_size = each.value.max_data_field_size
  name                = each.value.name
  rate_limit          = each.value.rate_limit
  organization {
    moid        = local.orgs[var.organization]
    object_type = "organization.Organization"
  }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
