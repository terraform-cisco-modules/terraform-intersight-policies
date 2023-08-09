#__________________________________________________________________
#
# Intersight Switch Control Policy
# GUI Location: Policies > Create Policy > Switch Control
#__________________________________________________________________

resource "intersight_fabric_switch_control_policy" "map" {
  for_each = {
    for v in lookup(local.policies, "switch_control", []) : v.name => merge(local.defaults.switch_control, v, {
      name         = "${local.npfx.switch_control}${v.name}${local.nsfx.switch_control}"
      organization = local.organization
      tags         = lookup(v, "tags", var.policies.global_settings.tags)
    })
  }
  description             = coalesce(each.value.description, "${each.value.name} Switch Control Policy.")
  ethernet_switching_mode = each.value.ethernet_switching_mode
  fc_switching_mode       = each.value.fc_switching_mode
  name                    = each.value.name
  reserved_vlan_start_id  = each.value.reserved_vlan_start_id
  #
  vlan_port_optimization_enabled = each.value.vlan_port_count_optimization
  mac_aging_settings {
    mac_aging_option = each.value.mac_address_table_aging
    mac_aging_time   = each.value.mac_address_table_aging == "Custom" ? each.value.mac_aging_time : null
  }
  organization {
    moid        = local.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  udld_settings {
    message_interval = each.value.udld_global_settings.message_interval
    recovery_action  = each.value.udld_global_settings.recovery_action
  }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
