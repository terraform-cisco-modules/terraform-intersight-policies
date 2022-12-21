#__________________________________________________________________
#
# Intersight LAN Connectivity Policy
# GUI Location: Policies > Create Policy > LAN Connectivity
#__________________________________________________________________

resource "intersight_vnic_lan_connectivity_policy" "lan_connectivity" {
  for_each            = local.lan_connectivity
  description         = lookup(each.value, "description", "${each.value.name} LAN Connectivity Policy.")
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
    for_each = { for v in compact([each.value.iqn_pool]) : v.name => v }
    content {
      moid = var.pools.iqn[iqn_pool.value].moid
    }
  }
  dynamic "tags" {
    for_each = each.value.tags
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

resource "intersight_vnic_eth_if" "vnics" {
  depends_on = [
    intersight_fabric_eth_network_control_policy.ethernet_network_control,
    intersight_fabric_eth_network_group_policy.ethernet_network_group,
    intersight_vnic_eth_adapter_policy.ethernet_adapter,
    intersight_vnic_eth_network_policy.ethernet_network,
    intersight_vnic_eth_qos_policy.ethernet_qos,
    intersight_vnic_iscsi_boot_policy.iscsi_boot,
    intersight_vnic_lan_connectivity_policy.lan_connectivity
  ]
  for_each         = local.vnics
  failover_enabled = each.value.enable_failover
  mac_address_type = each.value.mac_address_allocation_type
  name             = each.value.name
  order            = each.value.placement_pci_order
  static_mac_address = length(regexall("STATIC", each.value.mac_address_allocation_type)
  ) > 0 ? each.value.mac_address_static : null
  cdn {
    value     = each.value.cdn_source == "user" ? each.value.cdn_value : each.value.name
    nr_source = each.value.cdn_source
  }
  eth_adapter_policy {
    moid = intersight_vnic_eth_adapter_policy.ethernet_adapter[
      each.value.ethernet_adapter_policy
    ].moid
  }
  eth_qos_policy {
    moid = intersight_vnic_eth_qos_policy.ethernet_qos[each.value.ethernet_qos_policy].moid
  }
  fabric_eth_network_control_policy {
    moid = intersight_fabric_eth_network_control_policy.ethernet_network_control[
      each.value.ethernet_network_control_policy
    ].moid
  }
  lan_connectivity_policy {
    moid = intersight_vnic_lan_connectivity_policy.lan_connectivity[each.value.lan_connectivity].moid
  }
  placement {
    id        = each.value.placement_slot_id
    pci_link  = each.value.placement_pci_link
    switch_id = each.value.placement_switch_id
    uplink    = each.value.placement_uplink_port
  }
  usnic_settings {
    cos      = each.value.usnic_class_of_service
    nr_count = each.value.usnic_number_of_usnics
    usnic_adapter_policy = length(compact([each.value.usnic_adapter_policy])
      ) > 0 ? intersight_vnic_eth_adapter_policy.ethernet_adapter[
      each.value.usnic_adapter_policy
    ].moid : ""
  }
  vmq_settings {
    enabled             = each.value.vmq_enabled
    multi_queue_support = each.value.vmq_enable_virtual_machine_multi_queue
    num_interrupts      = each.value.vmq_number_of_interrupts
    num_vmqs            = each.value.vmq_number_of_virtual_machine_queues
    num_sub_vnics       = each.value.vmq_number_of_sub_vnics
    vmmq_adapter_policy = length(compact([each.value.vmq_vmmq_adapter_policy])
      ) > 0 ? intersight_vnic_eth_adapter_policy.ethernet_adapter[
      each.value.vmq_vmmq_adapter_policy
    ].moid : ""
  }
  dynamic "eth_network_policy" {
    for_each = { for v in compact([each.value.ethernet_network_policy]) : v => v }
    content {
      moid = intersight_vnic_eth_network_policy.ethernet_network[
        eth_network_policy.value
      ].moid
    }
  }
  dynamic "fabric_eth_network_group_policy" {
    for_each = { for v in compact([each.value.ethernet_network_group_policy]) : v => v }
    content {
      moid = intersight_fabric_eth_network_group_policy.ethernet_network_group[
        fabric_eth_network_group_policy.value
      ].moid
    }
  }
  dynamic "iscsi_boot_policy" {
    for_each = { for v in compact([each.value.iscsi_boot_policy]) : v => v }
    content {
      moid = intersight_vnic_iscsi_boot_policy.iscsi_boot[iscsi_boot_policy.value].moid

    }
  }
  dynamic "mac_pool" {
    for_each = {
      for v in compact(
        [each.value.mac_address_pool]
      ) : v => v if each.value.mac_address_allocation_type == "POOL"
    }
    content {
      moid = var.pools.mac[mac_pool.value]
    }
  }
  dynamic "tags" {
    for_each = each.value.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
