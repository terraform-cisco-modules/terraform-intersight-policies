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
  organization { moid = var.orgs[each.value.org] }
  dynamic "iqn_pool" {
    for_each = { for v in [each.value.iqn_pool] : v => v if element(split("/", v), 1) != "UNUSED" }
    content {
      moid        = contains(keys(local.pools.iqn.moids), iqn_pool.value) == true ? local.pools.iqn.moids[iqn_pool.value] : local.pools_data["iqn"][iqn_pool.value].moid
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
# vNIC Template(s)
# GUI Location: Templates > vNIC Templates > Create vNIC Template
#_________________________________________________________________________
#resource "intersight_vnic_vnic_template" "map" {
#  depends_on = [
#    intersight_fabric_eth_network_control_policy.map,
#    intersight_fabric_eth_network_group_policy.map,
#    intersight_vnic_eth_adapter_policy.map,
#    intersight_vnic_eth_qos_policy.map,
#    intersight_vnic_iscsi_boot_policy.map
#  ]
#  for_each         = local.vnic_template
#  enable_override  = each.value.allow_override
#  failover_enabled = each.value.enable_failover
#  name             = each.value.name
#  pin_group_name   = each.value.pin_group_name
#  switch_id        = each.value.placement_switch_id
#  organization { moid = var.orgs[each.value.org] }
#  cdn {
#    value     = each.value.cdn_source == "user" ? each.value.cdn_value : each.value.name
#    nr_source = each.value.cdn_source
#  }
#  eth_adapter_policy {
#    moid = contains(keys(local.ethernet_adapter), each.value.ethernet_adapter_policy) == true ? intersight_vnic_eth_adapter_policy.map[each.value.ethernet_adapter_policy
#    ].moid : local.policies_data["ethernet_adapter"][each.value.ethernet_adapter_policy].moid
#  }
#  eth_qos_policy {
#    moid = contains(keys(local.ethernet_qos), each.value.ethernet_qos_policy) == true ? intersight_vnic_eth_qos_policy.map[each.value.ethernet_qos_policy
#    ].moid : local.policies_data["ethernet_qos"][each.value.ethernet_qos_policy].moid
#  }
#  fabric_eth_network_control_policy {
#    moid = contains(keys(local.ethernet_network_control), each.value.ethernet_network_control_policy
#      ) == true ? intersight_fabric_eth_network_control_policy.map[each.value.ethernet_network_control_policy
#    ].moid : local.policies_data["ethernet_network_control"][each.value.ethernet_network_control_policy].moid
#  }
#  fabric_eth_network_group_policy {
#    moid = contains(keys(local.ethernet_network_group), each.value.ethernet_network_group_policy
#      ) == true ? intersight_fabric_eth_network_group_policy.map[each.value.ethernet_network_group_policy
#    ].moid : local.policies_data["ethernet_network_group"][each.value.ethernet_network_group_policy].moid
#  }
#  mac_pool {
#    moid = contains(keys(local.pools.mac.moids), each.value.mac_address_pool
#    ) == true ? local.pools.mac.moids[each.value.mac_address_pool] : local.pools_data["mac"][each.value.mac_address_pool].moid
#  }
#  sriov_settings {
#    comp_count_per_vf = each.value.sriov.completion_queue_count_per_vf
#    enabled           = each.value.sriov.enabled
#    int_count_per_vf  = each.value.sriov.interrupt_count_per_vf
#    rx_count_per_vf   = each.value.sriov.receive_queue_count_per_vf
#    tx_count_per_vf   = each.value.sriov.transmit_queue_count_per_vf
#    vf_count          = each.value.sriov.number_of_vfs
#  }
#  usnic_settings {
#    cos      = each.value.usnic.class_of_service
#    nr_count = each.value.usnic.number_of_usnics
#    usnic_adapter_policy = length(regexall("UNUSED", each.value.usnic.usnic_adapter_policy)) == 0 ? [
#      contains(keys(local.ethernet_adapter), each.value.usnic.usnic_adapter_policy
#        ) == true ? intersight_vnic_eth_adapter_policy.map[each.value.usnic.usnic_adapter_policy
#    ].moid : local.policies_data["ethernet_adapter"][each.value.usnic.usnic_adapter_policy].moid][0] : ""
#  }
#  vmq_settings {
#    enabled             = each.value.vmq.enabled
#    multi_queue_support = each.value.vmq.enable_virtual_machine_multi_queue
#    num_interrupts      = each.value.vmq.number_of_interrupts
#    num_vmqs            = each.value.vmq.number_of_virtual_machine_queues
#    num_sub_vnics       = each.value.vmq.number_of_sub_vnics
#    vmmq_adapter_policy = length(regexall("UNUSED", each.value.vmq.vmmq_adapter_policy)) == 0 ? [
#      contains(keys(local.ethernet_adapter), each.value.vmq.vmmq_adapter_policy
#        ) == true ? intersight_vnic_eth_adapter_policy.map[each.value.vmq.vmmq_adapter_policy
#    ].moid : local.policies_data["ethernet_adapter"][each.value.vmq.vmmq_adapter_policy].moid][0] : ""
#  }
#  dynamic "iscsi_boot_policy" {
#    for_each = { for v in [each.value.iscsi_boot_policy] : v => v if element(split("/", v), 1) != "UNUSED" }
#    content {
#      moid = contains(keys(local.iscsi_boot), "${iscsi_boot_policy.value.org}/${iscsi_boot_policy.value.name}"
#        ) == true ? intersight_vnic_iscsi_boot_policy.map["${iscsi_boot_policy.value.org}/${iscsi_boot_policy.value.name}"
#        ].moid : [for e in data.intersight_search_search_item.policies["iscsi_boot"
#          ].results : e.moid if jsondecode(e.additional_properties).Name == iscsi_boot_policy.value.name && jsondecode(e.additional_properties
#      ).Organization.Moid == var.orgs[iscsi_boot_policy.value.org]][0]
#    }
#  }
#  dynamic "tags" {
#    for_each = { for v in each.value.tags : v.key => v }
#    content {
#      key   = tags.value.key
#      value = tags.value.value
#    }
#  }
#}

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
  for_each           = local.vnics
  failover_enabled   = each.value.enable_failover
  mac_address_type   = length(compact([each.value.mac_address_static])) > 0 ? "STATIC" : "POOL"
  name               = each.value.name
  order              = each.value.placement.pci_order
  pin_group_name     = each.value.pin_group_name
  static_mac_address = length(compact([each.value.mac_address_static])) > 0 ? each.value.mac_address_static : null
  cdn {
    value     = each.value.cdn_source == "user" ? each.value.cdn_value : each.value.name
    nr_source = each.value.cdn_source
  }
  eth_adapter_policy {
    moid = contains(keys(local.ethernet_adapter), each.value.ethernet_adapter_policy) == true ? intersight_vnic_eth_adapter_policy.map[each.value.ethernet_adapter_policy
    ].moid : local.policies_data["ethernet_adapter"][each.value.ethernet_adapter_policy].moid
  }
  eth_qos_policy {
    moid = contains(keys(local.ethernet_qos), each.value.ethernet_qos_policy) == true ? intersight_vnic_eth_qos_policy.map[each.value.ethernet_qos_policy
    ].moid : local.policies_data["ethernet_qos"][each.value.ethernet_qos_policy].moid
  }
  fabric_eth_network_control_policy {
    moid = contains(keys(local.ethernet_network_control), each.value.ethernet_network_control_policy
      ) == true ? intersight_fabric_eth_network_control_policy.map[each.value.ethernet_network_control_policy
    ].moid : local.policies_data["ethernet_network_control"][each.value.ethernet_network_control_policy].moid
  }
  lan_connectivity_policy {
    moid = intersight_vnic_lan_connectivity_policy.map[each.value.lan_connectivity].moid
  }
  placement {
    auto_pci_link = each.value.placement.automatic_pci_link_assignment
    auto_slot_id  = each.value.placement.automatic_slot_id_assignment
    id            = each.value.placement.slot_id
    pci_link      = each.value.placement.pci_link
    switch_id     = each.value.placement.switch_id
    uplink        = each.value.placement.uplink_port
  }
  sriov_settings {
    comp_count_per_vf = each.value.sriov.completion_queue_count_per_vf
    enabled           = each.value.sriov.enabled
    int_count_per_vf  = each.value.sriov.interrupt_count_per_vf
    rx_count_per_vf   = each.value.sriov.receive_queue_count_per_vf
    tx_count_per_vf   = each.value.sriov.transmit_queue_count_per_vf
    vf_count          = each.value.sriov.number_of_vfs
  }
  usnic_settings {
    cos      = each.value.usnic.class_of_service
    nr_count = each.value.usnic.number_of_usnics
    usnic_adapter_policy = length(regexall("UNUSED", each.value.usnic.usnic_adapter_policy)) == 0 ? [
      contains(keys(local.ethernet_adapter), each.value.usnic.usnic_adapter_policy
        ) == true ? intersight_vnic_eth_adapter_policy.map[each.value.usnic.usnic_adapter_policy
    ].moid : local.policies_data["ethernet_adapter"][each.value.usnic.usnic_adapter_policy].moid][0] : ""
  }
  vmq_settings {
    enabled             = each.value.vmq.enabled
    multi_queue_support = each.value.vmq.enable_virtual_machine_multi_queue
    num_interrupts      = each.value.vmq.number_of_interrupts
    num_vmqs            = each.value.vmq.number_of_virtual_machine_queues
    num_sub_vnics       = each.value.vmq.number_of_sub_vnics
    vmmq_adapter_policy = length(regexall("UNUSED", each.value.vmq.vmmq_adapter_policy)) == 0 ? [
      contains(keys(local.ethernet_adapter), each.value.vmq.vmmq_adapter_policy
        ) == true ? intersight_vnic_eth_adapter_policy.map[each.value.vmq.vmmq_adapter_policy
    ].moid : local.policies_data["ethernet_adapter"][each.value.vmq.vmmq_adapter_policy].moid][0] : ""
  }
  dynamic "eth_network_policy" {
    for_each = { for v in [each.value.ethernet_network_policy] : v => v if element(split("/", v), 1) != "UNUSED" }
    content {
      moid = contains(keys(local.ethernet_network), eth_network_policy.value) == true ? intersight_vnic_eth_network_policy.map[eth_network_policy.value
      ].moid : local.policies_data["ethernet_network"][eth_network_policy.value].moid
    }
  }
  dynamic "fabric_eth_network_group_policy" {
    for_each = { for v in [each.value.ethernet_network_group_policy] : v => v if element(split("/", v), 1) != "UNUSED" }
    content {
      moid = contains(keys(local.ethernet_network_group), fabric_eth_network_group_policy.value
        ) == true ? intersight_fabric_eth_network_group_policy.map[fabric_eth_network_group_policy.value
      ].moid : local.policies_data["ethernet_network_group"][fabric_eth_network_group_policy.value].moid
    }
  }
  dynamic "iscsi_boot_policy" {
    for_each = { for v in [each.value.iscsi_boot_policy] : v => v if element(split("/", v), 1) != "UNUSED" }
    content {
      moid = contains(keys(local.iscsi_boot), iscsi_boot_policy.value) == true ? intersight_vnic_iscsi_boot_policy.map[iscsi_boot_policy.value
      ].moid : local.policies_data["iscsi_boot"][iscsi_boot_policy.value].moid
    }
  }
  dynamic "mac_pool" {
    for_each = { for v in [each.value.mac_address_pool] : v => v if element(split("/", v), 1) != "UNUSED" }
    content {
      moid = contains(keys(local.pools.mac.moids), mac_pool.value) == true ? local.pools.mac.moids[mac_pool.value] : local.pools_data["mac"][mac_pool.value].moid
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
# LAN Connectivity Policy - Add vNIC from Template
# GUI Location: Configure > Policies > Create Policy > LAN Connectivity
#_________________________________________________________________________
#resource "intersight_vnic_eth_if" "from_template" {
#  depends_on = [
#    intersight_fabric_eth_network_control_policy.map,
#    intersight_fabric_eth_network_group_policy.map,
#    intersight_vnic_lan_connectivity_policy.map,
#    intersight_vnic_eth_adapter_policy.map,
#    intersight_vnic_eth_network_policy.map,
#    intersight_vnic_eth_qos_policy.map,
#    intersight_vnic_iscsi_boot_policy.map,
#    intersight_vnic_vnic_template.map
#  ]
#  for_each           = local.vnics_from_template
#  mac_address_type   = length(compact([each.value.mac_address_static])) > 0 ? "STATIC" : "POOL"
#  name               = each.value.name
#  order              = each.value.placement.pci_order
#  pin_group_name     = each.value.pin_group_name
#  static_mac_address = length(compact([each.value.mac_address_static])) > 0 ? each.value.mac_address_static : null
#  cdn { value = local.vnic_condition_check[each.value.vnic_template].cdn_source == "user" ? each.value.cdn_value : each.value.name }
#  lan_connectivity_policy { moid = intersight_vnic_lan_connectivity_policy.map[each.value.lan_connectivity].moid }
#  placement {
#    auto_pci_link = each.value.placement.automatic_pci_link_assignment
#    auto_slot_id  = each.value.placement.automatic_slot_id_assignment
#    id            = each.value.placement.slot_id
#    pci_link      = each.value.placement.pci_link
#    switch_id     = local.vnic_condition_check[each.value.vnic_template].allow_override == true ? each.value.placement.switch_id : null
#    uplink        = each.value.placement.uplink_port
#  }
#  src_template {
#    moid = contains(keys(local.vnic_template), each.value.vnic_template) == true ? intersight_vnic_vnic_template.map[each.value.vnic_template
#    ].moid : local.data_vnic_template["map"][each.value.vnic_template].moid
#  }
#  dynamic "eth_adapter_policy" {
#    for_each = { for v in [each.value.ethernet_adapter_policy] : v => v if element(split("/", v), 1
#    ) != "UNUSED" && local.vnic_condition_check[each.value.vnic_template].allow_override == true }
#    content {
#      moid = contains(keys(local.ethernet_adapter), eth_adapter_policy.value) == true ? intersight_vnic_eth_adapter_policy.map[eth_adapter_policy.value
#      ].moid : local.policies_data["ethernet_adapter"][eth_adapter_policy.value].moid
#    }
#  }
#  dynamic "iscsi_boot_policy" {
#    for_each = { for v in [each.value.iscsi_boot_policy] : v => v if element(split("/", v), 1
#    ) != "UNUSED" && local.vnic_condition_check[each.value.vnic_template].allow_override == true }
#    content {
#      moid = contains(keys(local.iscsi_boot), iscsi_boot_policy.value) == true ? intersight_vnic_iscsi_boot_policy.map[iscsi_boot_policy.value
#      ].moid : local.policies_data["iscsi_boot"][iscsi_boot_policy.value].moid
#    }
#  }
#  dynamic "mac_pool" {
#    for_each = { for v in [each.value.mac_address_pool] : v => v if element(split("/", v), 1
#    ) != "UNUSED" && local.vnic_condition_check[each.value.vnic_template].allow_override == true }
#    content {
#      moid = contains(keys(local.pools.mac.moids), mac_pool.value) == true ? local.pools.mac.moids[mac_pool.value] : local.pools_data["mac"][mac_pool.value].moid
#    }
#  }
#  dynamic "sriov_settings" {
#    for_each = { for v in [each.value.sriov] : "sriov" => v if local.vnic_condition_check[each.value.vnic_template].proceed == true }
#    content {
#      comp_count_per_vf = sriov_settings.value.completion_queue_count_per_vf
#      enabled           = sriov_settings.value.enabled
#      int_count_per_vf  = sriov_settings.value.interrupt_count_per_vf
#      rx_count_per_vf   = sriov_settings.value.receive_queue_count_per_vf
#      tx_count_per_vf   = sriov_settings.value.transmit_queue_count_per_vf
#      vf_count          = sriov_settings.value.number_of_vfs
#    }
#  }
#  dynamic "tags" {
#    for_each = { for v in each.value.tags : v.key => v }
#    content {
#      key   = tags.value.key
#      value = tags.value.value
#    }
#  }
#  dynamic "usnic_settings" {
#    for_each = { for v in [each.value.usnic] : v => v if local.vnic_condition_check[each.value.vnic_template].proceed == true }
#    content {
#      cos      = usnic_settings.value.class_of_service
#      nr_count = usnic_settings.value.number_of_usnics
#      usnic_adapter_policy = length(regexall("UNUSED", usnic_settings.value.usnic_adapter_policy)) == 0 ? [
#        contains(keys(local.ethernet_adapter), usnic_settings.value.usnic_adapter_policy
#          ) == true ? intersight_vnic_eth_adapter_policy.map[usnic_settings.value.usnic_adapter_policy
#      ].moid : local.policies_data["ethernet_adapter"][usnic_settings.value.usnic_adapter_policy].moid][0] : ""
#    }
#  }
#  dynamic "vmq_settings" {
#    for_each = { for v in [each.value.vmq] : v => v if local.vnic_condition_check[each.value.vnic_template].proceed == true }
#    content {
#      enabled             = vmq_settings.value.enabled
#      multi_queue_support = vmq_settings.value.enable_virtual_machine_multi_queue
#      num_interrupts      = vmq_settings.value.number_of_interrupts
#      num_vmqs            = vmq_settings.value.number_of_virtual_machine_queues
#      num_sub_vnics       = vmq_settings.value.number_of_sub_vnics
#      vmmq_adapter_policy = length(regexall("UNUSED", vmq_settings.value.vmmq_adapter_policy)) == 0 ? [
#        contains(keys(local.ethernet_adapter), vmq_settings.value.vmmq_adapter_policy
#          ) == true ? intersight_vnic_eth_adapter_policy.map[vmq_settings.value.vmmq_adapter_policy
#      ].moid : local.policies_data["ethernet_adapter"][vmq_settings.value.vmmq_adapter_policy].moid][0] : ""
#    }
#  }
#}
