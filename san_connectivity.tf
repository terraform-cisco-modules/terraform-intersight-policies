#__________________________________________________________________
#
# Intersight SAN Connectivity Policy
# GUI Location: Policies > Create Policy > SAN Connectivity
#__________________________________________________________________

resource "intersight_vnic_san_connectivity_policy" "san_connectivity" {
  depends_on = [
    data.intersight_search_search_item.wwnn
  ]
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
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
  dynamic "wwnn_pool" {
    for_each = { for v in [each.value.wwnn_pool.name] : v => v if each.value.wwnn_pool.name != "UNUSED" }
    content {
      moid = length(regexall(false, var.moids_pools)) > 0 ? var.pools[each.value.wwnn_pool.org].wwnn[
        each.value.wwnn_pool.name
        ] : [for i in data.intersight_search_search_item.wwnn[0].results : i.moid if jsondecode(
          i.additional_properties).Organization.Moid == local.orgs[each.value.wwnn_pool.org
      ] && jsondecode(i.additional_properties).Name == each.value.wwnn_pool.name][0]
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
    data.intersight_search_search_item.fc_zone,
    data.intersight_search_search_item.fibre_channel_adapter,
    data.intersight_search_search_item.fibre_channel_network,
    data.intersight_search_search_item.fibre_channel_qos,
    intersight_fabric_fc_zone_policy.fc_zone,
    intersight_vnic_fc_adapter_policy.fibre_channel_adapter,
    intersight_vnic_fc_network_policy.fibre_channel_network,
    intersight_vnic_fc_qos_policy.fibre_channel_qos,
    intersight_vnic_san_connectivity_policy.san_connectivity
  ]
  for_each            = local.vhbas
  name                = each.value.name
  order               = each.value.placement.pci_order
  persistent_bindings = each.value.persistent_lun_bindings
  static_wwpn_address = each.value.wwpn_allocation_type == "STATIC" ? each.value.wwpn_static_address : ""
  type                = each.value.vhba_type
  wwpn_address_type   = each.value.wwpn_allocation_type
  fc_adapter_policy {
    moid = length(regexall(each.value.fibre_channel_adapter_policy.org, each.value.organization)
      ) > 0 ? intersight_vnic_fc_adapter_policy.fibre_channel_adapter[each.value.fibre_channel_adapter_policy.name
      ].moid : [for i in data.intersight_search_search_item.fibre_channel_adapter[0
        ].results : i.moid if jsondecode(
        i.additional_properties).Organization.Moid == local.orgs[each.value.fibre_channel_adapter_policy.org
    ] && jsondecode(i.additional_properties).Name == each.value.fibre_channel_adapter_policy.name][0]
  }
  fc_network_policy {
    moid = length(regexall(each.value.fibre_channel_network_policy.org, each.value.organization)
      ) > 0 ? intersight_vnic_fc_network_policy.fibre_channel_network[each.value.fibre_channel_network_policy.name
      ].moid : [for i in data.intersight_search_search_item.fibre_channel_network[0
        ].results : i.moid if jsondecode(
        i.additional_properties).Organization.Moid == local.orgs[each.value.fibre_channel_network_policy.org
    ] && jsondecode(i.additional_properties).Name == each.value.fibre_channel_network_policy.name][0]
  }
  fc_qos_policy {
    moid = length(regexall(each.value.fibre_channel_qos_policy.org, each.value.organization)
      ) > 0 ? intersight_vnic_fc_qos_policy.fibre_channel_qos[each.value.fibre_channel_qos_policy.name
      ].moid : [for i in data.intersight_search_search_item.fibre_channel_qos[0
        ].results : i.moid if jsondecode(
        i.additional_properties).Organization.Moid == local.orgs[each.value.fibre_channel_qos_policy.org
    ] && jsondecode(i.additional_properties).Name == each.value.fibre_channel_qos_policy.name][0]
  }
  san_connectivity_policy {
    moid = intersight_vnic_san_connectivity_policy.san_connectivity[each.value.san_connectivity].moid
  }
  placement {
    id        = each.value.placement.slot_id
    pci_link  = each.value.placement.pci_link
    switch_id = each.value.placement.switch_id
    uplink    = each.value.placement.uplink_port
  }
  dynamic "fc_zone_policies" {
    for_each = { for v in each.value.fc_zone_policies : v => v }
    content {
      moid = length(regexall(each.value.fc_zone_policies.org, each.value.organization)
        ) > 0 ? intersight_fabric_fc_zone_policy.fc_zone[each.value.fc_zone_policies.name
        ].moid : [for i in data.intersight_search_search_item.fc_zone[0].results : i.moid if jsondecode(
          i.additional_properties).Organization.Moid == local.orgs[each.value.fc_zone_policies.org
      ] && jsondecode(i.additional_properties).Name == each.value.fc_zone_policies.name][0]
    }
  }
  dynamic "wwpn_pool" {
    for_each = { for v in [each.value.wwpn_pool.name] : v => v if each.value.wwpn_pool.name != "UNUSED" }
    content {
      moid = length(regexall(false, var.moids_pools)) > 0 ? var.pools[each.value.wwpn_pool.org].wwpn[
        each.value.wwpn_pool.name
        ] : [for i in data.intersight_search_search_item.wwpn[0].results : i.moid if jsondecode(
          i.additional_properties).Organization.Moid == local.orgs[each.value.wwpn_pool.org
      ] && jsondecode(i.additional_properties).Name == each.value.wwpn_pool.name][0]
      object_type = "fcpool.Pool"
    }
  }
}
