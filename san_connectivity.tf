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
    for_each = { for v in [each.value.wwnn_pool] : v => v if element(split("/", v), 1) != "UNUSED" }
    content {
      moid = contains(keys(local.pools.wwnn.moids), wwnn_pool.value
      ) == true ? local.pools.wwnn.moids[wwnn_pool.value] : local.pools_data["wwnn"][wwnn_pool.value].moid
      object_type = "fcpool.Pool"
    }
  }
}

#_________________________________________________________________________
#
# vHBA Template(s)
# GUI Location: Templates > vHBA Templates > Create vHBA Template
#_________________________________________________________________________
resource "intersight_vnic_vhba_template" "map" {
  depends_on = [
    intersight_fabric_fc_zone_policy.map,
    intersight_vnic_fc_adapter_policy.map,
    intersight_vnic_fc_network_policy.map,
    intersight_vnic_fc_qos_policy.map
  ]
  for_each            = local.vhba_template
  enable_override     = each.value.allow_override
  name                = each.value.name
  persistent_bindings = each.value.persistent_lun_bindings
  type                = each.value.vhba_type
  fc_adapter_policy {
    moid = contains(keys(local.fibre_channel_adapter), each.value.fibre_channel_adapter_policy
      ) == true ? intersight_vnic_fc_adapter_policy.map[each.value.fibre_channel_adapter_policy
    ].moid : local.policies_data["fibre_channel_adapter"][each.value.fibre_channel_adapter_policy].moid
  }
  fc_network_policy {
    moid = contains(keys(local.fibre_channel_network), each.value.fibre_channel_network_policy
      ) == true ? intersight_vnic_fc_network_policy.map[each.value.fibre_channel_network_policy
    ].moid : local.policies_data["fibre_channel_network"][each.value.fibre_channel_network_policy].moid
  }
  fc_qos_policy {
    moid = contains(keys(local.fibre_channel_qos), each.value.fibre_channel_qos_policy) == true ? intersight_vnic_fc_qos_policy.map[each.value.fibre_channel_qos_policy
    ].moid : local.policies_data["fibre_channel_qos"][each.value.fibre_channel_qos_policy].moid
  }
  dynamic "fc_zone_policies" {
    for_each = { for v in each.value.fc_zone_policies : v => v if element(split("/", v), 1) != "UNUSED" }
    content {
      moid = contains(keys(local.fc_zone), fc_zone_policies.value) == true ? intersight_fabric_fc_zone_policy.map[fc_zone_policies.value
      ].moid : local.policies_data["fc_zone"][fc_zone_policies.value].moid
    }
  }
  dynamic "wwpn_pool" {
    for_each = { for v in [each.value.wwpn_pool] : v => v if element(split("/", v), 1) != "UNUSED" }
    content {
      moid = contains(keys(local.pools.wwpn.moids), wwpn_pool.value
      ) == true ? local.pools.wwpn.moids[wwpn_pool.value] : local.pools_data["wwpn_pool"][wwpn_pool.value].moid
      object_type = "fcpool.Pool"
    }
  }
}

#_________________________________________________________________________
#
# SAN Connectivity Policy - Add vHBA
# GUI Location: Configure > Policies > Create Policy > SAN Connectivity
#_________________________________________________________________________
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
    moid = contains(keys(local.fibre_channel_adapter), each.value.fibre_channel_adapter_policy
      ) == true ? intersight_vnic_fc_adapter_policy.map[each.value.fibre_channel_adapter_policy
    ].moid : local.policies_data["fibre_channel_adapter"][each.value.fibre_channel_adapter_policy].moid
  }
  fc_network_policy {
    moid = contains(keys(local.fibre_channel_network), each.value.fibre_channel_network_policy
      ) == true ? intersight_vnic_fc_network_policy.map[each.value.fibre_channel_network_policy
    ].moid : local.policies_data["fibre_channel_network"][each.value.fibre_channel_network_policy].moid
  }
  fc_qos_policy {
    moid = contains(keys(local.fibre_channel_qos), each.value.fibre_channel_qos_policy) == true ? intersight_vnic_fc_qos_policy.map[each.value.fibre_channel_qos_policy
    ].moid : local.policies_data["fibre_channel_qos"][each.value.fibre_channel_qos_policy].moid
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
    for_each = { for v in each.value.fc_zone_policies : v => v if element(split("/", v), 1) != "UNUSED" }
    content {
      moid = contains(keys(local.fc_zone), fc_zone_policies.value) == true ? intersight_fabric_fc_zone_policy.map[fc_zone_policies.value
      ].moid : local.policies_data["fc_zone"][fc_zone_policies.value].moid
    }
  }
  dynamic "wwpn_pool" {
    for_each = { for v in [each.value.wwpn_pool] : v => v if element(split("/", v), 1) != "UNUSED" }
    content {
      moid = contains(keys(local.pools.wwpn.moids), wwpn_pool.value
      ) == true ? local.pools.wwpn.moids[wwpn_pool.value] : local.pools_data["wwpn"][wwpn_pool.value].moid
      object_type = "fcpool.Pool"
    }
  }
}


#_________________________________________________________________________
#
# SAN Connectivity Policy - Add vHBA from Template
# GUI Location: Configure > Policies > Create Policy > SAN Connectivity
#_________________________________________________________________________
resource "intersight_vnic_fc_if" "from_template" {
  depends_on = [
    intersight_fabric_fc_zone_policy.map,
    intersight_vnic_fc_adapter_policy.map,
    intersight_vnic_fc_network_policy.map,
    intersight_vnic_fc_qos_policy.map,
    intersight_vnic_san_connectivity_policy.map
  ]
  for_each            = local.vhbas_from_template
  name                = each.value.name
  order               = each.value.placement.pci_order
  static_wwpn_address = each.value.wwpn_allocation_type == "STATIC" ? each.value.wwpn_static_address : ""
  wwpn_address_type   = each.value.wwpn_allocation_type
  san_connectivity_policy {
    moid = intersight_vnic_san_connectivity_policy.map[each.value.san_connectivity].moid
  }
  placement {
    id        = each.value.placement.slot_id
    pci_link  = each.value.placement.pci_link
    switch_id = each.value.placement.switch_id
    uplink    = each.value.placement.uplink_port
  }
  src_template {
    moid = contains(keys(local.vhba_template), each.value.vhba_template) == true ? intersight_vnic_vhba_template.map[each.value.vhba_template
    ].moid : local.data_vhba_template["map"][each.value.vhba_template].moid
  }
  dynamic "fc_adapter_policy" {
    for_each = { for v in each.value.fibre_channel_adapter : v => v if element(split("/", v), 1) != "UNUSED" }
    content {
      moid = contains(keys(local.fibre_channel_adapter), intersight_vnic_fc_adapter_policy.value) == true ? intersight_fabric_fc_zone_policy.map[fc_adapter_policy.value
      ].moid : local.policies_data["fibre_channel_adapter"][fc_adapter_policy.value].moid
    }
  }
  dynamic "fc_network_policy" {
    for_each = { for v in each.value.fibre_channel_network : v => v if element(split("/", v), 1) != "UNUSED" }
    content {
      moid = contains(keys(local.fibre_channel_network), intersight_vnic_fc_network_policy.value) == true ? fc_network_policy.map[fc_adapter_policy.value
      ].moid : local.policies_data["fibre_channel_network"][fc_network_policy.value].moid
    }
  }
  dynamic "fc_zone_policies" {
    for_each = { for v in each.value.fc_zone_policies : v => v if element(split("/", v), 1) != "UNUSED" }
    content {
      moid = contains(keys(local.fc_zone), fc_zone_policies.value) == true ? intersight_fabric_fc_zone_policy.map[fc_zone_policies.value
      ].moid : local.policies_data["fc_zone"][fc_zone_policies.value].moid
    }
  }
  dynamic "wwpn_pool" {
    for_each = { for v in [each.value.wwpn_pool] : v => v if element(split("/", v), 1) != "UNUSED" }
    content {
      moid = contains(keys(local.pools.wwpn.moids), wwpn_pool.value
      ) == true ? local.pools.wwpn.moids[wwpn_pool.value] : local.pools_data["wwpn"][wwpn_pool.value].moid
      object_type = "fcpool.Pool"
    }
  }
}
