#__________________________________________________________________
#
# Intersight LAN Connectivity Policy
# GUI Location: Policies > Create Policy > LAN Connectivity
#__________________________________________________________________

resource "intersight_vnic_lan_connectivity_policy" "map" {
  for_each            = local.lan_connectivity
  description         = coalesce(each.value.description, "${each.value.name} LAN Connectivity Policy.")
  azure_qos_enabled   = each.value.enable_azure_stack_host_qos
  iqn_allocation_type = each.value.iqn_allocation_type
  name                = each.value.name
  placement_mode      = each.value.vnic_placement_mode
  static_iqn_name     = each.value.iqn_static_identifier
  target_platform     = each.value.target_platform
  organization { moid = var.orgs[each.value.organization] }
  dynamic "iqn_pool" {
    for_each = { for v in [each.value.iqn_pool] : "${v.org}/${v.name}" => v if v.name != "UNUSED" }
    content {
      moid = contains(keys(local.pools["iqn"].moids), "${iqn_pool.value.org}/${iqn_pool.value.name}"
        ) == true ? local.pools.iqn.moids["${iqn_pool.value.org}/${iqn_pool.value.name}"] : [for i in data.intersight_search_search_item.pools["iqn"
          ].results : i.moid if jsondecode(i.additional_properties).Name == iqn_pool.value.name && jsondecode(i.additional_properties
      ).Organization.Moid == var.orgs[iqn_pool.value.org]][0]
      object_type = "iqnpool.Pool"
    }
  }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}


#_________________________________________________________________________
#
# LAN Connectivity Policy - Add vNIC(s)
# GUI Location: Configure > Policies > Create Policy > LAN Connectivity
#_________________________________________________________________________

resource "intersight_vnic_eth_if" "map" {
  depends_on = [
    intersight_fabric_eth_network_control_policy.map,
    intersight_fabric_eth_network_group_policy.map,
    intersight_vnic_lan_connectivity_policy.map,
    intersight_vnic_eth_adapter_policy.map,
    intersight_vnic_eth_network_policy.map,
    intersight_vnic_eth_qos_policy.map,
    intersight_vnic_iscsi_boot_policy.map
  ]
  for_each         = local.vnics
  failover_enabled = each.value.enable_failover
  mac_address_type = each.value.mac_address_allocation_type
  name             = each.value.name
  order            = each.value.placement.pci_order
  static_mac_address = length(regexall("STATIC", each.value.mac_address_allocation_type)
  ) > 0 ? each.value.mac_address_static : null
  cdn {
    value     = each.value.cdn_source == "user" ? each.value.cdn_value : each.value.name
    nr_source = each.value.cdn_source
  }
  eth_adapter_policy {
    moid = contains(keys(local.ethernet_adapter), "${each.value.ethernet_adapter_policy.org}/${each.value.ethernet_adapter_policy.name}"
      ) == true ? intersight_vnic_eth_adapter_policy.map["${each.value.ethernet_adapter_policy.org}/${each.value.ethernet_adapter_policy.name}"
      ].moid : [for i in data.intersight_search_search_item.policies["ethernet_adapter"
        ].results : i.moid if jsondecode(i.additional_properties).Name == each.value.ethernet_adapter_policy.name && jsondecode(i.additional_properties
    ).Organization.Moid == var.orgs[each.value.ethernet_adapter_policy.org]][0]
  }
  eth_qos_policy {
    moid = contains(keys(local.ethernet_qos), "${each.value.ethernet_qos_policy.org}/${each.value.ethernet_qos_policy.name}"
      ) == true ? intersight_vnic_eth_qos_policy.map["${each.value.ethernet_qos_policy.org}/${each.value.ethernet_qos_policy.name}"
      ].moid : [for i in data.intersight_search_search_item.policies["ethernet_qos"
        ].results : i.moid if jsondecode(i.additional_properties).Name == each.value.ethernet_qos_policy.name && jsondecode(i.additional_properties
    ).Organization.Moid == var.orgs[each.value.ethernet_qos_policy.org]][0]
  }
  fabric_eth_network_control_policy {
    moid = contains(keys(local.ethernet_network_control), "${each.value.ethernet_network_control_policy.org}/${each.value.ethernet_network_control_policy.name}"
      ) == true ? intersight_fabric_eth_network_control_policy.map["${each.value.ethernet_network_control_policy.org}/${each.value.ethernet_network_control_policy.name}"
      ].moid : [for i in data.intersight_search_search_item.policies["ethernet_network_control"
        ].results : i.moid if jsondecode(i.additional_properties).Name == each.value.ethernet_network_control_policy.name && jsondecode(i.additional_properties
    ).Organization.Moid == var.orgs[each.value.ethernet_network_control_policy.org]][0]
  }
  lan_connectivity_policy {
    moid = intersight_vnic_lan_connectivity_policy.map[each.value.lan_connectivity].moid
  }
  placement {
    id        = each.value.placement.slot_id
    pci_link  = each.value.placement.pci_link
    switch_id = each.value.placement.switch_id
    uplink    = each.value.placement.uplink_port
  }
  usnic_settings {
    cos      = each.value.usnic_settings.class_of_service
    nr_count = each.value.usnic_settings.number_of_usnics
    usnic_adapter_policy = length(regexall("UNUSED", each.value.usnic_settings.usnic_adapter_policy.name)
      ) == 0 ? [contains(keys(local.ethernet_adapter), "${each.value.usnic_settings.usnic_adapter_policy.org}/${each.value.usnic_settings.usnic_adapter_policy.name}"
        ) == true ? intersight_fabric_eth_network_control_policy.map["${each.value.usnic_settings.usnic_adapter_policy.org}/${each.value.usnic_settings.usnic_adapter_policy.name}"
        ].moid : [for i in data.intersight_search_search_item.policies["ethernet_adapter"
          ].results : i.moid if jsondecode(i.additional_properties).Name == each.value.usnic_settings.usnic_adapter_policy.name && jsondecode(i.additional_properties
    ).Organization.Moid == var.orgs[each.value.usnic_settings.usnic_adapter_policy.org]][0]][0] : ""
  }
  vmq_settings {
    enabled             = each.value.vmq_settings.enabled
    multi_queue_support = each.value.vmq_settings.enable_virtual_machine_multi_queue
    num_interrupts      = each.value.vmq_settings.number_of_interrupts
    num_vmqs            = each.value.vmq_settings.number_of_virtual_machine_queues
    num_sub_vnics       = each.value.vmq_settings.number_of_sub_vnics
    vmmq_adapter_policy = length(regexall("UNUSED", each.value.vmq_settings.vmmq_adapter_policy.name)
      ) == 0 ? [contains(keys(local.ethernet_adapter), "${each.value.vmq_settings.vmmq_adapter_policy.org}/${each.value.vmq_settings.vmmq_adapter_policy.name}"
        ) == true ? intersight_fabric_eth_network_control_policy.map["${each.value.vmq_settings.vmmq_adapter_policy.org}/${each.value.vmq_settings.vmmq_adapter_policy.name}"
        ].moid : [for i in data.intersight_search_search_item.policies["ethernet_adapter"
          ].results : i.moid if jsondecode(i.additional_properties).Name == each.value.vmq_settings.vmmq_adapter_policy.name && jsondecode(i.additional_properties
    ).Organization.Moid == var.orgs[each.value.vmq_settings.vmmq_adapter_policy.org]][0]][0] : ""
  }
  dynamic "eth_network_policy" {
    for_each = { for v in [each.value.ethernet_network_policy] : v.name => v if v.name != "UNUSED" }
    content {
      moid = contains(keys(local.ethernet_network), "${eth_network_policy.value.org}/${eth_network_policy.value.name}"
        ) == true ? intersight_vnic_eth_network_policy.map["${eth_network_policy.value.org}/${eth_network_policy.value.name}"
        ].moid : [for i in data.intersight_search_search_item.policies["ethernet_network"
          ].results : i.moid if jsondecode(i.additional_properties).Name == eth_network_policy.value.name && jsondecode(i.additional_properties
      ).Organization.Moid == var.orgs[eth_network_policy.value.org]][0]
    }
  }
  dynamic "fabric_eth_network_group_policy" {
    for_each = { for v in [each.value.ethernet_network_group_policy] : v.name => v if v.name != "UNUSED" }
    content {
      moid = contains(keys(local.ethernet_network_group), "${fabric_eth_network_group_policy.value.org}/${fabric_eth_network_group_policy.value.name}"
        ) == true ? intersight_fabric_eth_network_group_policy.map["${fabric_eth_network_group_policy.value.org}/${fabric_eth_network_group_policy.value.name}"
        ].moid : [for i in data.intersight_search_search_item.policies["ethernet_network_group"
          ].results : i.moid if jsondecode(i.additional_properties).Name == fabric_eth_network_group_policy.value.name && jsondecode(i.additional_properties
      ).Organization.Moid == var.orgs[fabric_eth_network_group_policy.value.org]][0]
    }
  }
  dynamic "iscsi_boot_policy" {
    for_each = { for v in [each.value.iscsi_boot_policy] : v.name => v if v.name != "UNUSED" }
    content {
      moid = contains(keys(local.iscsi_boot), "${iscsi_boot_policy.value.org}/${iscsi_boot_policy.value.name}"
        ) == true ? intersight_vnic_iscsi_boot_policy.map["${iscsi_boot_policy.value.org}/${iscsi_boot_policy.value.name}"
        ].moid : [for i in data.intersight_search_search_item.policies["iscsi_boot"
          ].results : i.moid if jsondecode(i.additional_properties).Name == iscsi_boot_policy.value.name && jsondecode(i.additional_properties
      ).Organization.Moid == var.orgs[iscsi_boot_policy.value.org]][0]
    }
  }
  dynamic "mac_pool" {
    for_each = {
      for v in [each.value.mac_address_pool] : v.name => v if v.name != "UNUSED"
    }
    content {
      moid = contains(keys(local.pools["mac"].moids), "${mac_pool.value.org}/${mac_pool.value.name}"
        ) == true ? local.pools.mac.moids["${mac_pool.value.org}/${mac_pool.value.name}"] : [for i in data.intersight_search_search_item.pools["mac"
          ].results : i.moid if jsondecode(i.additional_properties).Name == mac_pool.value.name && jsondecode(i.additional_properties
      ).Organization.Moid == var.orgs[mac_pool.value.org]][0]
    }
  }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
