#__________________________________________________________________
#
# Intersight Ethernet Network Control Policy
# GUI Location: Policies > Create Policy > Ethernet Network Control
#__________________________________________________________________

resource "intersight_fabric_eth_network_control_policy" "map" {
  for_each              = local.ethernet_network_control
  cdp_enabled           = each.value.cdp_enable
  description           = coalesce(each.value.description, "${each.value.name} Ethernet Network Control Policy.")
  forge_mac             = each.value.mac_security_forge
  name                  = each.value.name
  mac_registration_mode = each.value.mac_register_mode
  uplink_fail_action    = each.value.action_on_uplink_fail
  lldp_settings {
    object_type      = "fabric.LldpSettings"
    receive_enabled  = each.value.lldp_enable_receive
    transmit_enabled = each.value.lldp_enable_transmit
  }
  organization { moid = var.orgs[each.value.organization] }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
