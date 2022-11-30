#__________________________________________________________________
#
# Intersight SAN Connectivity Policy
# GUI Location: Policies > Create Policy > SAN Connectivity
#__________________________________________________________________

resource "intersight_vnic_san_connectivity_policy" "san_connectivity" {
  for_each            = local.san_connectivity
  description         = lookup(each.value, "description", "${each.value.name} SAN Connectivity Policy.")
  name                = each.value.name
  placement_mode      = each.value.vhba_placement_mode
  static_wwnn_address = each.value.wwnn_static_address
  target_platform     = each.value.target_platform
  wwnn_address_type   = each.value.wwnn_allocation_type
  organization {
    moid        = local.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  dynamic "tags" {
    for_each = each.value.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
  dynamic "wwnn_pool" {
    for_each = { for v in compact([each.value.wwnn_pool]) : v => v }
    content {
      moid = var.pools.wwnn[wwnn_pool.value]
    }
  }
}


#____________________________________________________________
#
# Intersight Fibre Channel (vHBA) Policy
# GUI Location: Policies > Create Policy
#____________________________________________________________

resource "intersight_vnic_fc_if" "vhbas" {
  depends_on = [
    intersight_fabric_fc_zone_policy.fc_zone,
    intersight_vnic_fc_adapter_policy.fibre_channel_adapter,
    intersight_vnic_fc_network_policy.fibre_channel_network,
    intersight_vnic_fc_qos_policy.fibre_channel_qos,
    intersight_vnic_san_connectivity_policy.san_connectivity
  ]
  for_each            = local.vhbas
  name                = each.value.name
  order               = each.value.placement_pci_order
  persistent_bindings = each.value.persistent_lun_bindings
  static_wwpn_address = each.value.wwpn_allocation_type == "STATIC" ? each.value.wwpn_static_address : ""
  type                = each.value.vhba_type
  wwpn_address_type   = each.value.wwpn_allocation_type
  fc_adapter_policy {
    moid = intersight_vnic_fc_adapter_policy.fibre_channel_adapter[each.value.fibre_channel_adapter_policy].moid
  }
  fc_network_policy {
    moid = intersight_vnic_fc_network_policy.fibre_channel_network[each.value.fibre_channel_network_policy].moid
  }
  fc_qos_policy {
    moid = intersight_vnic_fc_qos_policy.fibre_channel_qos[each.value.fibre_channel_qos_policy].moid
  }
  san_connectivity_policy {
    moid = intersight_vnic_san_connectivity_policy.san_connectivity[each.value.san_connectivity].moid
  }
  placement {
    id        = each.value.placement_slot_id
    pci_link  = each.value.placement_pci_link
    switch_id = each.value.placement_switch_id
    uplink    = each.value.placement_uplink_port
  }
  dynamic "fc_zone_policies" {
    for_each = { for v in each.value.fc_zone_policies : v => v }
    content {
      moid = intersight_fabric_fc_zone_policy.fc_zone_policies[fc_zone_policies.value].moid
    }
  }
  dynamic "wwpn_pool" {
    for_each = { for v in compact([each.value.wwpn_pool]) : v => v }
    content {
      moid = var.pools.wwpn[wwpn_pool.value]
    }
  }
}
