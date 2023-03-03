#__________________________________________________________________
#
# Intersight Switch Control Policy
# GUI Location: Policies > Create Policy > Switch Control
#__________________________________________________________________

resource "intersight_fabric_switch_control_policy" "switch_control" {
  for_each                       = local.switch_control
  description                    = lookup(each.value, "description", "${each.value.name} Switch Control Policy.")
  ethernet_switching_mode        = each.value.ethernet_switching_mode
  fc_switching_mode              = each.value.fc_switching_mode
  name                           = each.value.name
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
    message_interval = each.value.udld_message_interval
    recovery_action  = each.value.udld_recovery_action
  }
  dynamic "profiles" {
    for_each = { for v in each.value.profiles : v => v }
    content {
      moid        = var.domains[var.organization].switch_profiles[profiles.value].moid
      object_type = "fabric.SwitchProfile"
    }
  }
  dynamic "tags" {
    for_each = each.value.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
