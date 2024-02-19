#__________________________________________________________________
#
# Intersight SAN Connectivity Policy
# GUI Location: Policies > Create Policy > SAN Connectivity
#__________________________________________________________________

resource "intersight_vnic_san_connectivity_policy" "map" {
  for_each            = local.san_connectivity
  description         = coalesce(each.value.description, "${each.value.name} SAN Connectivity Policy.")
  name                = each.value.name
  placement_mode      = each.value.vhba_placement_mode
  static_wwnn_address = each.value.wwnn_static_address
  target_platform     = each.value.target_platform
  wwnn_address_type   = each.value.wwnn_allocation_type
  organization { moid = var.orgs[each.value.organization] }
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
      moid = contains(keys(local.pools["wwnn"].moids), "${wwnn_pool.value.org}/${wwnn_pool.value.name}"
        ) == true ? local.pools.wwnn.moids["${wwnn_pool.value.org}/${wwnn_pool.value.name}"] : [for i in data.intersight_search_search_item.pools["wwnn"
          ].results : i.moid if jsondecode(i.additional_properties).Name == wwnn_pool.value.name && jsondecode(i.additional_properties
      ).Organization.Moid == var.orgs[wwnn_pool.value.org]][0]
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
    intersight_fabric_fc_zone_policy.map,
    intersight_vnic_fc_adapter_policy.map,
    intersight_vnic_fc_network_policy.map,
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
    moid = contains(keys(local.fibre_channel_adapter), "${each.value.fibre_channel_adapter_policy.org}/${each.value.fibre_channel_adapter_policy.name}"
      ) == true ? intersight_vnic_fc_adapter_policy.map["${each.value.fibre_channel_adapter_policy.org}/${each.value.fibre_channel_adapter_policy.name}"
      ].moid : [for i in data.intersight_search_search_item.policies["fibre_channel_adapter"
        ].results : i.moid if jsondecode(i.additional_properties).Name == each.value.fibre_channel_adapter_policy.name && jsondecode(i.additional_properties
    ).Organization.Moid == var.orgs[each.value.fibre_channel_adapter_policy.org]][0]
  }
  fc_network_policy {
    moid = contains(keys(local.fibre_channel_network), "${each.value.fibre_channel_network_policy.org}/${each.value.fibre_channel_network_policy.name}"
      ) == true ? intersight_vnic_fc_network_policy.map["${each.value.fibre_channel_network_policy.org}/${each.value.fibre_channel_network_policy.name}"
      ].moid : [for i in data.intersight_search_search_item.policies["fibre_channel_network"
        ].results : i.moid if jsondecode(i.additional_properties).Name == each.value.fibre_channel_network_policy.name && jsondecode(i.additional_properties
    ).Organization.Moid == var.orgs[each.value.fibre_channel_network_policy.org]][0]
  }
  fc_qos_policy {
    moid = contains(keys(local.fibre_channel_qos), "${each.value.fibre_channel_qos_policy.org}/${each.value.fibre_channel_qos_policy.name}"
      ) == true ? intersight_vnic_fc_qos_policy.map["${each.value.fibre_channel_qos_policy.org}/${each.value.fibre_channel_qos_policy.name}"
      ].moid : [for i in data.intersight_search_search_item.policies["fibre_channel_qos"
        ].results : i.moid if jsondecode(i.additional_properties).Name == each.value.fibre_channel_qos_policy.name && jsondecode(i.additional_properties
    ).Organization.Moid == var.orgs[each.value.fibre_channel_qos_policy.org]][0]
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
      moid = contains(keys(local.fc_zone), "${fc_zone_policies.value.org}/${fc_zone_policies.value.name}"
        ) == true ? intersight_fabric_fc_zone_policy.map["${fc_zone_policies.value.org}/${fc_zone_policies.value.name}"
        ].moid : [for i in data.intersight_search_search_item.policies["fc_zone"
          ].results : i.moid if jsondecode(i.additional_properties).Name == fc_zone_policies.value.name && jsondecode(i.additional_properties
      ).Organization.Moid == var.orgs[fc_zone_policies.value.org]][0]
    }
  }
  dynamic "wwpn_pool" {
    for_each = { for v in [each.value.wwpn_pool] : v.name => v if v.name != "UNUSED" }
    content {
      moid = contains(keys(local.pools.wwpn.moids), "${wwpn_pool.value.org}/${wwpn_pool.value.name}"
        ) == true ? local.pools.wwpn.moids["${wwpn_pool.value.org}/${wwpn_pool.value.name}"] : [for i in data.intersight_search_search_item.pools["wwpn"
          ].results : i.moid if jsondecode(i.additional_properties).Name == wwpn_pool.value.name && jsondecode(i.additional_properties
      ).Organization.Moid == var.orgs[wwpn_pool.value.org]][0]
      object_type = "fcpool.Pool"
    }
  }
}
