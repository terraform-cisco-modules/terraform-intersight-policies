#__________________________________________________________________
#
# Intersight LAN Connectivity Policy
# GUI Location: Policies > Create Policy > LAN Connectivity
#__________________________________________________________________

resource "intersight_vnic_lan_connectivity_policy" "map" {
  depends_on = [
    data.intersight_search_search_item.iqn
  ]
  for_each            = local.lan_connectivity
  description         = coalesce(each.value.description, "${each.value.name} LAN Connectivity Policy.")
  azure_qos_enabled   = each.value.enable_azure_stack_host_qos
  iqn_allocation_type = each.value.iqn_allocation_type
  name                = each.value.name
  placement_mode      = each.value.vnic_placement_mode
  static_iqn_name     = each.value.iqn_static_identifier
  target_platform     = each.value.target_platform
  organization {
    moid        = local.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  dynamic "iqn_pool" {
    for_each = { for v in [each.value.iqn_pool.name] : v => v if each.value.iqn_pool.name != "UNUSED" }
    content {
      moid = length(regexall(false, local.moids_pools)) > 0 ? local.pools[each.value.iqn_pool.org].iqn[
        each.value.iqn_pool.name
        ] : [for i in data.intersight_search_search_item.iqn[0].results : i.moid if jsondecode(
          i.additional_properties).Organization.Moid == local.orgs[each.value.iqn_pool.org
      ] && jsondecode(i.additional_properties).Name == each.value.iqn_pool.name][0]
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
    data.intersight_search_search_item.ethernet_adapter,
    data.intersight_search_search_item.ethernet_network,
    data.intersight_search_search_item.ethernet_network_control,
    data.intersight_search_search_item.ethernet_network_group,
    data.intersight_search_search_item.ethernet_qos,
    data.intersight_search_search_item.iscsi_boot,
    intersight_fabric_eth_network_control_policy.map,
    intersight_fabric_eth_network_group_policy.map,
    intersight_vnic_lan_connectivity_policy.map,
    intersight_vnic_eth_adapter_policy.map,
    intersight_vnic_eth_network_policy.map,
    intersight_vnic_eth_qos_policy.map,
    intersight_vnic_iscsi_boot_policy.map,
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
    moid = length(regexall(false, local.moids_policies)) > 0 && length(regexall(
      each.value.ethernet_adapter_policy.org, each.value.organization)
      ) > 0 ? intersight_vnic_eth_adapter_policy.map[each.value.ethernet_adapter_policy.name
      ].moid : [for i in data.intersight_search_search_item.ethernet_adapter[0].results : i.moid if jsondecode(
        i.additional_properties).Organization.Moid == local.orgs[each.value.ethernet_adapter_policy.org
    ] && jsondecode(i.additional_properties).Name == each.value.ethernet_adapter_policy.name][0]
  }
  eth_qos_policy {
    moid = length(regexall(false, local.moids_policies)) > 0 && length(regexall(
      each.value.ethernet_qos_policy.org, each.value.organization)
      ) > 0 ? intersight_vnic_eth_qos_policy.map[each.value.ethernet_qos_policy.name
      ].moid : [for i in data.intersight_search_search_item.ethernet_qos[0].results : i.moid if jsondecode(
        i.additional_properties).Organization.Moid == local.orgs[each.value.ethernet_qos_policy.org
    ] && jsondecode(i.additional_properties).Name == each.value.ethernet_qos_policy.name][0]
  }
  fabric_eth_network_control_policy {
    moid = length(regexall(false, local.moids_policies)) > 0 && length(regexall(
      each.value.ethernet_network_control_policy.org, each.value.organization)
      ) > 0 ? intersight_fabric_eth_network_control_policy.map[
      each.value.ethernet_network_control_policy.name
      ].moid : [for i in data.intersight_search_search_item.ethernet_network_control[0].results : i.moid if jsondecode(
        i.additional_properties).Organization.Moid == local.orgs[each.value.ethernet_network_control_policy.org
    ] && jsondecode(i.additional_properties).Name == each.value.ethernet_network_control_policy.name][0]
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
      ) == 0 ? length(regexall(false, local.moids_policies)) > 0 && length(regexall(
      each.value.usnic_settings.usnic_adapter_policy.org, each.value.organization)
      ) > 0 ? intersight_vnic_eth_adapter_policy.map[each.value.usnic_settings.usnic_adapter_policy.name
      ].moid : [for i in data.intersight_search_search_item.ethernet_adapter[0].results : i.moid if jsondecode(
        i.additional_properties).Organization.Moid == local.orgs[each.value.usnic_adapter_policy.org
    ] && jsondecode(i.additional_properties).Name == each.value.usnic_settings.usnic_adapter_policy.name][0] : ""
  }
  vmq_settings {
    enabled             = each.value.vmq_settings.enabled
    multi_queue_support = each.value.vmq_settings.enable_virtual_machine_multi_queue
    num_interrupts      = each.value.vmq_settings.number_of_interrupts
    num_vmqs            = each.value.vmq_settings.number_of_virtual_machine_queues
    num_sub_vnics       = each.value.vmq_settings.number_of_sub_vnics
    vmmq_adapter_policy = length(regexall("UNUSED", each.value.vmq_settings.vmmq_adapter_policy.name)
      ) == 0 ? length(regexall(each.value.vmq_settings.vmmq_adapter_policy.org, each.value.organization)
      ) > 0 ? intersight_vnic_eth_adapter_policy.map[each.value.vmq_settings.vmmq_adapter_policy.name
      ].moid : [for i in data.intersight_search_search_item.ethernet_adapter[0].results : i.moid if jsondecode(
        i.additional_properties).Organization.Moid == local.orgs[each.value.vmq_settings.vmmq_adapter_policy.org
    ] && jsondecode(i.additional_properties).Name == each.value.vmq_settings.vmmq_adapter_policy.name][0] : ""
  }
  dynamic "eth_network_policy" {
    for_each = {
      for v in [each.value.ethernet_network_policy.name] : v => v if each.value.ethernet_network_policy.name != "UNUSED"
    }
    content {
      moid = length(regexall(each.value.ethernet_network_policy.org, each.value.organization)
        ) > 0 ? intersight_vnic_eth_network_policy.map[each.value.ethernet_network_policy.name
        ].moid : [for i in data.intersight_search_search_item.ethernet_network[0].results : i.moid if jsondecode(
          i.additional_properties).Organization.Moid == local.orgs[each.value.ethernet_network_policy.org
      ] && jsondecode(i.additional_properties).Name == each.value.ethernet_network_policy.name][0]
    }
  }
  dynamic "fabric_eth_network_group_policy" {
    for_each = {
      for v in [each.value.ethernet_network_group_policy.name
      ] : v => v if each.value.ethernet_network_group_policy.name != "UNUSED"
    }
    content {
      moid = length(regexall(each.value.ethernet_network_group_policy.org, each.value.organization)
        ) > 0 ? intersight_fabric_eth_network_group_policy.map[
        each.value.ethernet_network_group_policy.name
        ].moid : [for i in data.intersight_search_search_item.ethernet_network_group[0].results : i.moid if jsondecode(
          i.additional_properties).Organization.Moid == local.orgs[each.value.ethernet_network_group_policy.org
      ] && jsondecode(i.additional_properties).Name == each.value.ethernet_network_group_policy.name][0]
    }
  }
  dynamic "iscsi_boot_policy" {
    for_each = {
      for v in [each.value.iscsi_boot_policy.name] : v => v if each.value.iscsi_boot_policy.name != "UNUSED"
    }
    content {
      moid = length(regexall(each.value.ethernet_network_control_policy.org, each.value.organization)
        ) > 0 ? intersight_fabric_eth_network_control_policy.map[
        each.value.ethernet_network_control_policy.name
        ].moid : [for i in data.intersight_search_search_item.iscsi_boot[0].results : i.moid if jsondecode(
          i.additional_properties).Organization.Moid == local.orgs[each.value.iscsi_boot_policy.org
      ] && jsondecode(i.additional_properties).Name == each.value.iscsi_boot_policy.name][0]
    }
  }
  dynamic "mac_pool" {
    for_each = {
      for v in [each.value.mac_address_pool.name] : v => v if each.value.mac_address_pool.name != "UNUSED"
    }
    content {
      moid = length(regexall(false, local.moids_pools)) > 0 ? local.pools[each.value.mac_address_pool.org].mac[
        each.value.mac_address_pool.name
        ] : [for i in data.intersight_search_search_item.mac[0].results : i.moid if jsondecode(
          i.additional_properties).Organization.Moid == local.orgs[each.value.mac_address_pool.org
      ] && jsondecode(i.additional_properties).Name == each.value.mac_address_pool.name][0]
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
