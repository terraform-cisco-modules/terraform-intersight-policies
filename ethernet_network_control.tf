#__________________________________________________________________
#
# Intersight Ethernet Network Control Policy
# GUI Location: Policies > Create Policy > Ethernet Network Control
#__________________________________________________________________

resource "intersight_fabric_eth_network_control_policy" "ethernet_network_control" {
  for_each = { for v in lookup(local.policies, "ethernet_network_control", []) : v.name => v }
  cdp_enabled = lookup(
    each.value, "cdp_enable", local.defaults.intersight.policies.ethernet_network_control.cdp_enable
  )
  description = lookup(each.value, "description", "${each.value.name} Ethernet Network Control Policy.")
  forge_mac = lookup(
    each.value, "mac_security_forge", local.defaults.intersight.policies.ethernet_network_control.mac_security_forge
  )
  mac_registration_mode = lookup(
    each.value, "mac_register_mode", local.defaults.intersight.policies.ethernet_network_control.mac_register_mode
  )
  name = "${each.key}${local.defaults.intersight.policies.ethernet_network_control.name_suffix}"
  uplink_fail_action = lookup(
    each.value, "action_on_uplink_fail", local.defaults.intersight.policies.ethernet_network_control.action_on_uplink_fail
  )
  lldp_settings {
    object_type = "fabric.LldpSettings"
    receive_enabled = lookup(
      each.value, "lldp_enable_receive", local.defaults.intersight.policies.ethernet_network_control.lldp_enable_receive
    )
    transmit_enabled = lookup(
      each.value, "lldp_enable_transmit", local.defaults.intersight.policies.ethernet_network_control.lldp_enable_transmit
    )
  }
  organization {
    moid        = local.orgs[lookup(each.value, "organization", var.organization)]
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
