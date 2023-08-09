#__________________________________________________________________
#
# Intersight Fibre Channel Network Policy
# GUI Location: Policies > Create Policy > Fibre Channel Network
#__________________________________________________________________

resource "intersight_vnic_fc_network_policy" "map" {
  for_each = { for v in lookup(local.policies, "fibre_channel_network", []) : v.name => merge(local.fcn, v, {
    name = "${local.name_prefix.fibre_channel_network}${v.name}${local.name_suffix.fibre_channel_network}"
    tags = lookup(v, "tags", var.policies.global_settings.tags)
  }) }
  description = coalesce(each.value.description, "${each.value.name} Fibre-Channel Network Policy.")
  name        = each.value.name
  organization {
    moid        = local.orgs[local.organization]
    object_type = "organization.Organization"
  }
  vsan_settings {
    default_vlan_id = each.value.default_vlan_id
    id              = each.value.vsan_id
  }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
