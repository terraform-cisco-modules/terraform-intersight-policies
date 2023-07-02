#__________________________________________________________________
#
# Intersight Ethernet Network Control Policy
# GUI Location: Policies > Create Policy > Ethernet Network Control
#__________________________________________________________________

resource "intersight_fabric_eth_network_control_policy" "ethernet_network_control" {
  for_each = { for v in lookup(local.policies, "ethernet_network_control", []) : v.name => v }
  cdp_enabled = lookup(
    each.value, "cdp_enable", local.defaults.ethernet_network_control.cdp_enable
  )
  description = lookup(
  each.value, "description", "${local.name_prefix.ethernet_network_control}${each.key}${local.name_suffix.ethernet_network_control} Ethernet Network Control Policy.")
  forge_mac = lookup(
    each.value, "mac_security_forge", local.defaults.ethernet_network_control.mac_security_forge
  )
  mac_registration_mode = lookup(
    each.value, "mac_register_mode", local.defaults.ethernet_network_control.mac_register_mode
  )
  name = "${local.name_prefix.ethernet_network_control}${each.key}${local.name_suffix.ethernet_network_control}"
  uplink_fail_action = lookup(
    each.value, "action_on_uplink_fail", local.defaults.ethernet_network_control.action_on_uplink_fail
  )
  lldp_settings {
    object_type = "fabric.LldpSettings"
    receive_enabled = lookup(
      each.value, "lldp_enable_receive", local.defaults.ethernet_network_control.lldp_enable_receive
    )
    transmit_enabled = lookup(
      each.value, "lldp_enable_transmit", local.defaults.ethernet_network_control.lldp_enable_transmit
    )
  }
  organization {
    moid        = local.orgs[var.organization]
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
