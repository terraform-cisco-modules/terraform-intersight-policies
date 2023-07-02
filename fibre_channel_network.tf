#__________________________________________________________________
#
# Intersight Fibre Channel Network Policy
# GUI Location: Policies > Create Policy > Fibre Channel Network
#__________________________________________________________________

resource "intersight_vnic_fc_network_policy" "fibre_channel_network" {
  for_each = { for v in lookup(local.policies, "fibre_channel_network", []) : v.name => v }
  description = lookup(
  each.value, "description", "${local.name_prefix.fibre_channel_network}${each.key}${local.name_suffix.fibre_channel_network} Fibre-Channel Network Policy.")
  name = "${local.name_prefix.fibre_channel_network}${each.key}${local.name_suffix.fibre_channel_network}"
  organization {
    moid        = local.orgs[var.organization]
    object_type = "organization.Organization"
  }
  vsan_settings {
    default_vlan_id = lookup(
      each.value, "default_vlan_id", local.defaults.fibre_channel_network.default_vlan_id
    )
    id = each.value.vsan_id
  }
  dynamic "tags" {
    for_each = lookup(each.value, "tags", var.tags)
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
