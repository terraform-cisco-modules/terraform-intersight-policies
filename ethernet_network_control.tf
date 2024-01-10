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
  organization {
    moid        = local.orgs[local.organization]
    object_type = "organization.Organization"
  }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

resource "intersight_fabric_eth_network_control_policy" "data" {
  depends_on = [intersight_fabric_eth_network_control_policy.map]
  for_each = {
    for v in local.pp.ethernet_network_control : v => v if lookup(local.ethernet_network_control, element(split(":", v), 1), "#NOEXIST") == "#NOEXIST"
  }
  name = element(split(":", each.value), 1)
  organization {
    moid = local.orgs[element(split(":", each.value), 0)]
  }
  lifecycle {
    ignore_changes = [
      account_moid, additional_properties, ancestors, cdp_enabled, create_time, description, domain_group_moid, forge_mac, lldp_settings,
      mac_registration_mode, mod_time, owners, parent, permission_resources, shared_scope, tags, uplink_fail_action, version_context
    ]
    prevent_destroy = true
  }
}
