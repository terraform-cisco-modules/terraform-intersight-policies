#__________________________________________________________________
#
# Intersight Fibre Channel Network Policy
# GUI Location: Policies > Create Policy > Fibre Channel Network
#__________________________________________________________________

resource "intersight_vnic_fc_network_policy" "fibre_channel_network" {
  for_each    = { for v in lookup(local.policies, "fibre_channel_network", []) : v.name => v }
  description = lookup(each.value, "description", "${each.value.name} Fibre-Channel Network Policy.")
  name        = "${each.key}${local.defaults.intersight.policies.fibre_channel_network.name_suffix}"
  organization {
    moid        = local.orgs[lookup(each.value, "organization", var.organization)]
    object_type = "organization.Organization"
  }
  vsan_settings {
    default_vlan_id = lookup(
      each.value, "default_vlan_id", local.defaults.intersight.policies.fibre_channel_network.default_vlan_id
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
