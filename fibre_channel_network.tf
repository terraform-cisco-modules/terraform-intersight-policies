#__________________________________________________________________
#
# Intersight Fibre Channel Network Policy
# GUI Location: Policies > Create Policy > Fibre Channel Network
#__________________________________________________________________

resource "intersight_vnic_fc_network_policy" "map" {
  for_each    = local.fibre_channel_network
  description = coalesce(each.value.description, "${each.value.name} Fibre-Channel Network Policy.")
  name        = each.value.name
  organization { moid = var.orgs[each.value.organization] }
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

resource "intersight_vnic_fc_network_policy" "data" {
  depends_on = [intersight_vnic_fc_network_policy.map]
  for_each   = { for v in local.pp.fc_network : v => v if lookup(local.fibre_channel_network, v, "#NOEXIST") == "#NOEXIST" }
  name       = element(split("/", each.value), 1)
  organization { moid = var.orgs[element(split("/", each.value), 0)] }
  lifecycle {
    ignore_changes = [
      account_moid, additional_properties, ancestors, create_time, description, domain_group_moid, mod_time, owners,
      parent, permission_resources, shared_scope, tags, version_context, vsan_settings
    ]
    prevent_destroy = true
  }
}
