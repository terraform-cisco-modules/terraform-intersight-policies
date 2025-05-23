#__________________________________________________________________
#
# Intersight Switch Control Policy
# GUI Location: Policies > Create Policy > Switch Control
#__________________________________________________________________
resource "intersight_fabric_switch_control_policy" "map" {
  for_each = local.switch_control
  additional_properties = each.value.aes_primary_key != 0 ? jsonencode({
    AesPrimaryKey = local.ps.switch_control.aes_primary_key[each.value.aes_primary_key]
  }) : jsonencode({})
  description             = coalesce(each.value.description, "${each.value.name} Switch Control Policy.")
  ethernet_switching_mode = each.value.switching_mode_ethernet
  fabric_pc_vhba_reset    = each.value.fabric_port_channel_vhba_reset
  fc_switching_mode       = each.value.switching_mode_fc
  name                    = each.value.name
  reserved_vlan_start_id  = each.value.reserved_vlan_start_id
  #
  vlan_port_optimization_enabled = each.value.vlan_port_count_optimization
  mac_aging_settings {
    mac_aging_option = each.value.mac_address_table_aging
    mac_aging_time   = each.value.mac_address_table_aging == "Custom" ? each.value.mac_aging_time : null
  }
  organization { moid = var.orgs[each.value.org] }
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
