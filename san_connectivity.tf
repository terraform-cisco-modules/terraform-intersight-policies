#__________________________________________________________________
#
# Intersight SAN Connectivity Policy
# GUI Location: Policies > Create Policy > SAN Connectivity
#__________________________________________________________________

resource "intersight_vnic_san_connectivity_policy" "map" {
  depends_on          = [intersight_fcpool_pool.wwnn]
  for_each            = local.san_connectivity
  description         = coalesce(each.value.description, "${each.value.name} SAN Connectivity Policy.")
  name                = each.value.name
  placement_mode      = each.value.vhba_placement_mode
  static_wwnn_address = each.value.wwnn_static_address
  target_platform     = each.value.target_platform
  wwnn_address_type   = each.value.wwnn_allocation_type
  organization {
    moid        = var.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
  dynamic "wwnn_pool" {
    for_each = { for v in [each.value.wwnn_pool] : v.name => v if v.name != "UNUSED" }
    content {
      moid = length(regexall("#EXIST", lookup(lookup(lookup(var.pools, wwnn_pool.value.org, {}), "wwnn", {}), wwnn_pool.value.name, "#EXIST"))
      ) == 0 ? var.pools[mac_pool.value.org].wwnn[wwnn_pool.value.name] : intersight_macpool_pool.data["${wwnn_pool.value.org}:${wwnn_pool.value.name}"].moid
      object_type = "fcpool.Pool"
    }
  }
}


#____________________________________________________________
#
# Intersight Fibre Channel (vHBA) Policy
# GUI Location: Policies > Create Policy
#____________________________________________________________

resource "intersight_vnic_fc_if" "map" {
  depends_on = [
    intersight_fabric_fc_zone_policy.data,
    intersight_fabric_fc_zone_policy.map,
    intersight_vnic_fc_adapter_policy.data,
    intersight_vnic_fc_adapter_policy.map,
    intersight_vnic_fc_network_policy.data,
    intersight_vnic_fc_network_policy.map,
    intersight_vnic_fc_qos_policy.data,
    intersight_vnic_fc_qos_policy.map,
    intersight_vnic_san_connectivity_policy.map
  ]
  for_each            = local.vhbas
  name                = each.value.name
  order               = each.value.placement.pci_order
  persistent_bindings = each.value.persistent_lun_bindings
  static_wwpn_address = each.value.wwpn_allocation_type == "STATIC" ? each.value.wwpn_static_address : ""
  type                = each.value.vhba_type
  wwpn_address_type   = each.value.wwpn_allocation_type
  fc_adapter_policy {
    moid = lookup(local.fibre_channel_adapter, each.value.fibre_channel_adapter_policy.name, "#NOEXIST"
      ) != "#NOEXIST" ? intersight_vnic_fc_adapter_policy.map[each.value.fibre_channel_adapter_policy.name
    ].moid : intersight_vnic_fc_adapter_policy.data["${each.value.fibre_channel_adapter_policy.org}:${each.value.fibre_channel_adapter_policy.name}"].moid
  }
  fc_network_policy {
    moid = lookup(local.fibre_channel_network, each.value.fibre_channel_network_policy.name, "#NOEXIST"
      ) != "#NOEXIST" ? intersight_vnic_fc_network_policy.map[each.value.fibre_channel_network_policy.name
    ].moid : intersight_vnic_fc_network_policy.data["${each.value.fibre_channel_network_policy.org}:${each.value.fibre_channel_network_policy.name}"].moid
  }
  fc_qos_policy {
    moid = lookup(local.fibre_channel_qos, each.value.fibre_channel_qos_policy.name, "#NOEXIST"
      ) != "#NOEXIST" ? intersight_vnic_fc_network_policy.map[each.value.fibre_channel_qos_policy.name
    ].moid : intersight_vnic_fc_network_policy.data["${each.value.fibre_channel_qos_policy.org}:${each.value.fibre_channel_qos_policy.name}"].moid
  }
  san_connectivity_policy {
    moid = intersight_vnic_san_connectivity_policy.map[each.value.san_connectivity].moid
  }
  placement {
    id        = each.value.placement.slot_id
    pci_link  = each.value.placement.pci_link
    switch_id = each.value.placement.switch_id
    uplink    = each.value.placement.uplink_port
  }
  dynamic "fc_zone_policies" {
    for_each = { for v in each.value.fc_zone_policies : v.name => v if v.name != "UNUSED" }
    content {
      moid = lookup(local.fc_zone, fc_zone_policies.value.name, "#NOEXIST"
        ) != "#NOEXIST" ? intersight_fabric_fc_zone_policy.map[fc_zone_policies.value.name
      ].moid : intersight_fabric_fc_zone_policy.data["${fc_zone_policies.value.org}:${fc_zone_policies.value.name}"].moid
    }
  }
  dynamic "wwpn_pool" {
    for_each = { for v in [each.value.wwpn_pool] : v.name => v if v.name != "UNUSED" }
    content {
      moid = length(regexall("#EXIST", lookup(lookup(lookup(var.pools, wwpn_pool.value.org, {}), "wwpn", {}), wwpn_pool.value.name, "#EXIST"))
      ) == 0 ? var.pools[mac_pool.value.org].wwpn[wwpn_pool.value.name] : intersight_macpool_pool.data["${wwpn_pool.value.org}:${wwpn_pool.value.name}"].moid
    }
  }
}
