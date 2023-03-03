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
    for_each = { for v in [each.value.wwnn_pool.name] : v => v if each.value.wwnn_pool.name != "UNUSED" }
    content {
      moid = [for i in data.intersight_fcpool_pool.wwnn[0].results : i.moid if i.organization[0
      ].moid == local.orgs[each.value.wwnn_pool.organization] && i.name == each.value.wwnn_pool.name][0]
      object_type = "fcpool.Pool"
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
    data.intersight_fabric_fc_zone_policy.fc_zone,
    data.intersight_vnic_fc_adapter_policy.fibre_channel_adapter,
    data.intersight_vnic_fc_network_policy.fibre_channel_network,
    data.intersight_vnic_fc_qos_policy.fibre_channel_qos,
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
    moid = [for i in data.intersight_vnic_fc_adapter_policy.fibre_channel_adapter[0
      ].results : i.moid if i.organization[0].moid == local.orgs[
      each.value.fibre_channel_adapter_policy.organization
    ] && i.name == each.value.fibre_channel_adapter_policy.name][0]
  }
  fc_network_policy {
    moid = [for i in data.intersight_vnic_fc_network_policy.fibre_channel_network[0
      ].results : i.moid if i.organization[0].moid == local.orgs[
      each.value.fibre_channel_network_policy.organization
    ] && i.name == each.value.fibre_channel_network_policy.name][0]
  }
  fc_qos_policy {
    moid = [for i in data.intersight_vnic_fc_qos_policy.fibre_channel_qos[0
      ].results : i.moid if i.organization[0].moid == local.orgs[
      each.value.fibre_channel_qos_policy.organization
    ] && i.name == each.value.fibre_channel_qos_policy.name][0]
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
      moid = [for i in data.intersight_fabric_fc_zone_policy.fc_zone[0].results : i.moid if i.organization[0
      ].moid == local.orgs[var.organization] && i.name == fc_zone_policies.value][0]
    }
  }
  dynamic "wwpn_pool" {
    for_each = { for v in [each.value.wwpn_pool.name] : v => v if each.value.wwpn_pool.name != "UNUSED" }
    content {
      moid = [for i in data.intersight_fcpool_pool.wwpn[0].results : i.moid if i.organization[0
      ].moid == local.orgs[each.value.wwpn_pool.organization] && i.name == each.value.wwpn_pool.name][0]
      object_type = "fcpool.Pool"
    }
  }
}
