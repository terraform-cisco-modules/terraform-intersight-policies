locals {
  defaults   = lookup(var.model, "defaults", {})
  domains    = var.domains
  modules    = lookup(var.model, "modules", {})
  intersight = lookup(var.model, "intersight", {})
  orgs       = var.pools.orgs
  pools      = var.pools
  policies   = lookup(local.intersight, "policies", {})
}

#_________________________________________________________________
#
# Intersight Adapter Configuration Policy
# GUI Location: Policies > Create Policy > Adapter Configuration
#_________________________________________________________________

module "adapter_configuration" {
  source  = "terraform-cisco-modules/policies-adapter-configuration/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "adapter_configuration", []) : v.name => v if lookup(
      local.modules.policies, "adapter_configuration", true
    )
  }
  adapter_ports = lookup(
    each.value, "adapter_ports", local.defaults.intersight.policies.adapter_configuration.adapter_ports
  )
  description = lookup(each.value, "description", "")
  enable_fip = lookup(
    each.value, "enable_fip", local.defaults.intersight.policies.adapter_configuration.enable_fip
  )
  enable_lldp = lookup(
    each.value, "enable_lldp", local.defaults.intersight.policies.adapter_configuration.enable_lldp
  )
  enable_port_channel = lookup(
    each.value, "enable_port_channel", local.defaults.intersight.policies.adapter_configuration.enable_port_channel
  )
  fec_modes = lookup(
    each.value, "fec_modes", local.defaults.intersight.policies.adapter_configuration.fec_modes
  )
  name = "${each.value.name}${local.defaults.intersight.policies.adapter_configuration.name_suffix}"
  pci_slot = lookup(
    each.value, "pci_slot", local.defaults.intersight.policies.adapter_configuration.pci_slot
  )
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#__________________________________________________________________
#
# Intersight Boot Order Policy
# GUI Location: Policies > Create Policy > Boot Order
#__________________________________________________________________

module "boot_order" {
  source  = "terraform-cisco-modules/policies-boot-order/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "boot_order", []) : v.name => v if lookup(
      local.modules.policies, "boot_order", true
    )
  }
  boot_devices = lookup(each.value, "boot_devices", [])
  boot_mode    = lookup(each.value, "boot_mode", local.defaults.intersight.policies.boot_order.boot_mode)
  description  = lookup(each.value, "description", "")
  enable_secure_boot = lookup(
    each.value, "enable_secure_boot", local.defaults.intersight.policies.boot_order.enable_secure_boot
  )
  name         = "${each.value.name}${local.defaults.intersight.policies.boot_order.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#__________________________________________________________________
#
# Intersight Certificate Management Policy
# GUI Location: Policies > Create Policy > Certificate Management
#__________________________________________________________________

module "certificate_management" {
  source  = "terraform-cisco-modules/policies-certificate-management/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "certificate_management", []) : v.name => v if lookup(
      local.modules.policies, "certificate_management", true
    )
  }
  base64_certificate   = lookup(each.value, "base64_certificate", 1)
  base64_certificate_1 = var.base64_certificate_1
  base64_certificate_2 = var.base64_certificate_2
  base64_certificate_3 = var.base64_certificate_3
  base64_certificate_5 = var.base64_certificate_4
  base64_certificate_4 = var.base64_certificate_5
  base64_private_key   = lookup(each.value, "base64_private_key", 1)
  base64_private_key_1 = var.base64_private_key_1
  base64_private_key_2 = var.base64_private_key_2
  base64_private_key_3 = var.base64_private_key_3
  base64_private_key_4 = var.base64_private_key_4
  base64_private_key_5 = var.base64_private_key_5
  description          = lookup(each.value, "description", "")
  name                 = "${each.value.name}${local.defaults.intersight.policies.certificate_management.name_suffix}"
  organization         = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags                 = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#__________________________________________________________________
#
# Intersight Device Connector Policy
# GUI Location: Policies > Create Policy > Device Connector
#__________________________________________________________________

module "device_connector" {
  source  = "terraform-cisco-modules/policies-device-connector/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "device_connector", []) : v.name => v if lookup(
      local.modules.policies, "device_connector", true
    )
  }
  configuration_lockout = lookup(
    each.value, "configuration_lockout", local.defaults.intersight.policies.device_connector.configuration_lockout
  )
  description  = lookup(each.value, "description", "")
  name         = "${each.value.name}${local.defaults.intersight.policies.device_connector.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#__________________________________________________________________
#
# Intersight Ethernet Adapter Policy
# GUI Location: Policies > Create Policy > Ethernet Adapter
#__________________________________________________________________

module "ethernet_adapter" {
  source  = "terraform-cisco-modules/policies-ethernet-adapter/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "ethernet_adapter", []) : v.name => v if lookup(
      local.modules.policies, "ethernet_adapter", true
    )
  }
  completion_queue_count                   = lookup(each.value, "completion_queue_count", local.defaults.intersight.policies.ethernet_adapter.completion_queue_count)
  completion_ring_size                     = lookup(each.value, "completion_ring_size", local.defaults.intersight.policies.ethernet_adapter.completion_ring_size)
  description                              = lookup(each.value, "description", "")
  enable_accelerated_receive_flow_steering = lookup(each.value, "enable_accelerated_receive_flow_steering", local.defaults.intersight.policies.ethernet_adapter.enable_accelerated_receive_flow_steering)
  enable_advanced_filter                   = lookup(each.value, "enable_advanced_filter", local.defaults.intersight.policies.ethernet_adapter.enable_advanced_filter)
  enable_geneve_offload                    = lookup(each.value, "enable_geneve_offload", local.defaults.intersight.policies.ethernet_adapter.enable_geneve_offload)
  enable_interrupt_scaling                 = lookup(each.value, "enable_interrupt_scaling", local.defaults.intersight.policies.ethernet_adapter.enable_interrupt_scaling)
  enable_nvgre_offload                     = lookup(each.value, "enable_nvgre_offload", local.defaults.intersight.policies.ethernet_adapter.enable_nvgre_offload)
  enable_vxlan_offload                     = lookup(each.value, "enable_vxlan_offload", local.defaults.intersight.policies.ethernet_adapter.enable_vxlan_offload)
  interrupt_coalescing_type                = lookup(each.value, "interrupt_coalescing_type", local.defaults.intersight.policies.ethernet_adapter.interrupt_coalescing_type)
  interrupt_mode                           = lookup(each.value, "interrupt_mode", local.defaults.intersight.policies.ethernet_adapter.interrupt_mode)
  interrupt_timer                          = lookup(each.value, "interrupt_timer", local.defaults.intersight.policies.ethernet_adapter.interrupt_timer)
  interrupts                               = lookup(each.value, "interrupts", local.defaults.intersight.policies.ethernet_adapter.interrupts)
  name                                     = "${each.value.name}${local.defaults.intersight.policies.ethernet_adapter.name_suffix}"
  organization                             = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  receive_side_scaling_enable              = lookup(each.value, "receive_side_scaling_enable", local.defaults.intersight.policies.ethernet_adapter.receive_side_scaling_enable)
  roce_cos                                 = lookup(each.value, "roce_cos", local.defaults.intersight.policies.ethernet_adapter.roce_cos)
  roce_enable                              = lookup(each.value, "roce_enable", local.defaults.intersight.policies.ethernet_adapter.roce_enable)
  roce_memory_regions                      = lookup(each.value, "roce_memory_regions", local.defaults.intersight.policies.ethernet_adapter.roce_memory_regions)
  roce_queue_pairs                         = lookup(each.value, "roce_queue_pairs", local.defaults.intersight.policies.ethernet_adapter.roce_queue_pairs)
  roce_resource_groups                     = lookup(each.value, "roce_resource_groups", local.defaults.intersight.policies.ethernet_adapter.roce_resource_groups)
  roce_version                             = lookup(each.value, "roce_version", local.defaults.intersight.policies.ethernet_adapter.roce_version)
  rss_enable_ipv4_hash                     = lookup(each.value, "rss_enable_ipv4_hash", local.defaults.intersight.policies.ethernet_adapter.rss_enable_ipv4_hash)
  rss_enable_ipv6_extensions_hash          = lookup(each.value, "rss_enable_ipv6_extensions_hash", local.defaults.intersight.policies.ethernet_adapter.rss_enable_ipv6_extensions_hash)
  rss_enable_ipv6_hash                     = lookup(each.value, "rss_enable_ipv6_hash", local.defaults.intersight.policies.ethernet_adapter.rss_enable_ipv6_hash)
  rss_enable_tcp_and_ipv4_hash             = lookup(each.value, "rss_enable_tcp_and_ipv4_hash", local.defaults.intersight.policies.ethernet_adapter.rss_enable_tcp_and_ipv4_hash)
  rss_enable_tcp_and_ipv6_extensions_hash  = lookup(each.value, "rss_enable_tcp_and_ipv6_extensions_hash", local.defaults.intersight.policies.ethernet_adapter.rss_enable_tcp_and_ipv6_extensions_hash)
  rss_enable_tcp_and_ipv6_hash             = lookup(each.value, "rss_enable_tcp_and_ipv6_hash", local.defaults.intersight.policies.ethernet_adapter.rss_enable_tcp_and_ipv6_hash)
  rss_enable_udp_and_ipv4_hash             = lookup(each.value, "rss_enable_udp_and_ipv4_hash", local.defaults.intersight.policies.ethernet_adapter.rss_enable_udp_and_ipv4_hash)
  rss_enable_udp_and_ipv6_hash             = lookup(each.value, "rss_enable_udp_and_ipv6_hash", local.defaults.intersight.policies.ethernet_adapter.rss_enable_udp_and_ipv6_hash)
  receive_queue_count                      = lookup(each.value, "receive_queue_count", local.defaults.intersight.policies.ethernet_adapter.receive_queue_count)
  receive_ring_size                        = lookup(each.value, "receive_ring_size", local.defaults.intersight.policies.ethernet_adapter.receive_ring_size)
  tags                                     = lookup(each.value, "tags", local.defaults.intersight.tags)
  tcp_offload_large_recieve                = lookup(each.value, "tcp_offload_large_recieve", local.defaults.intersight.policies.ethernet_adapter.tcp_offload_large_recieve)
  tcp_offload_large_send                   = lookup(each.value, "tcp_offload_large_send", local.defaults.intersight.policies.ethernet_adapter.tcp_offload_large_send)
  tcp_offload_rx_checksum                  = lookup(each.value, "tcp_offload_rx_checksum", local.defaults.intersight.policies.ethernet_adapter.tcp_offload_rx_checksum)
  tcp_offload_tx_checksum                  = lookup(each.value, "tcp_offload_tx_checksum", local.defaults.intersight.policies.ethernet_adapter.tcp_offload_tx_checksum)
  transmit_queue_count                     = lookup(each.value, "transmit_queue_count", local.defaults.intersight.policies.ethernet_adapter.transmit_queue_count)
  transmit_ring_size                       = lookup(each.value, "transmit_ring_size", local.defaults.intersight.policies.ethernet_adapter.transmit_ring_size)
  uplink_failback_timeout                  = lookup(each.value, "uplink_failback_timeout", local.defaults.intersight.policies.ethernet_adapter.uplink_failback_timeout)
}


#__________________________________________________________________
#
# Intersight Ethernet Network Policy
# GUI Location: Policies > Create Policy > Ethernet Network
#__________________________________________________________________

module "ethernet_network" {
  source  = "terraform-cisco-modules/policies-ethernet-network/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "ethernet_network", []) : v.name => v if lookup(
      local.modules.policies, "ethernet_network", true
    )
  }
  default_vlan = lookup(each.value, "default_vlan", local.defaults.intersight.policies.ethernet_network.default_vlan)
  description  = lookup(each.value, "description", "")
  name         = "${each.value.name}${local.defaults.intersight.policies.ethernet_network.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
  vlan_mode    = lookup(each.value, "vlan_mode", local.defaults.intersight.policies.ethernet_network.vlan_mode)
}


#__________________________________________________________________
#
# Intersight Ethernet Network Control Policy
# GUI Location: Policies > Create Policy > Ethernet Network Control
#__________________________________________________________________

module "ethernet_network_control" {
  source  = "terraform-cisco-modules/policies-ethernet-network-control/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "ethernet_network_control", []) : v.name => v if lookup(
      local.modules.policies, "ethernet_network_control", true
    )
  }
  action_on_uplink_fail = lookup(
    each.value, "action_on_uplink_fail", local.defaults.intersight.policies.ethernet_network_control.action_on_uplink_fail
  )
  cdp_enable = lookup(
    each.value, "cdp_enable", local.defaults.intersight.policies.ethernet_network_control.cdp_enable
  )
  description = lookup(each.value, "description", "")
  lldp_enable_receive = lookup(
    each.value, "lldp_enable_receive", local.defaults.intersight.policies.ethernet_network_control.lldp_enable_receive
  )
  lldp_enable_transmit = lookup(
    each.value, "lldp_enable_transmit", local.defaults.intersight.policies.ethernet_network_control.lldp_enable_transmit
  )
  mac_register_mode = lookup(
    each.value, "mac_register_mode", local.defaults.intersight.policies.ethernet_network_control.mac_register_mode
  )
  mac_security_forge = lookup(
    each.value, "mac_security_forge", local.defaults.intersight.policies.ethernet_network_control.mac_security_forge
  )
  name         = "${each.value.name}${local.defaults.intersight.policies.ethernet_network_control.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#__________________________________________________________________
#
# Intersight Ethernet Network Group Policy
# GUI Location: Policies > Create Policy > Ethernet Network Group
#__________________________________________________________________

module "ethernet_network_group" {
  source  = "terraform-cisco-modules/policies-ethernet-network-group/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "ethernet_network_group", []) : v.name => v if lookup(
      local.modules.policies, "ethernet_network_group", true
    )
  }
  allowed_vlans = each.value.allowed_vlans
  description   = lookup(each.value, "description", "")
  name          = "${each.value.name}${local.defaults.intersight.policies.ethernet_network_group.name_suffix}"
  native_vlan   = lookup(each.value, "native_vlan", null)
  organization  = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags          = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#__________________________________________________________________
#
# Intersight Ethernet QoS Policy
# GUI Location: Policies > Create Policy > Ethernet QoS
#__________________________________________________________________

module "ethernet_qos" {
  source  = "terraform-cisco-modules/policies-ethernet-qos/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "ethernet_qos", []) : v.name => v if lookup(
      local.modules.policies, "ethernet_qos", true
    )
  }
  burst                 = lookup(each.value, "burst", local.defaults.intersight.policies.ethernet_qos.burst)
  cos                   = lookup(each.value, "cos", local.defaults.intersight.policies.ethernet_qos.cos)
  description           = lookup(each.value, "description", "")
  enable_trust_host_cos = lookup(each.value, "enable_trust_host_cos", local.defaults.intersight.policies.ethernet_qos.enable_trust_host_cos)
  mtu                   = lookup(each.value, "mtu", local.defaults.intersight.policies.ethernet_qos.mtu)
  name                  = "${each.value.name}${local.defaults.intersight.policies.ethernet_qos.name_suffix}"
  organization          = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  priority              = lookup(each.value, "priority", local.defaults.intersight.policies.ethernet_qos.priority)
  rate_limit            = lookup(each.value, "rate_limit", local.defaults.intersight.policies.ethernet_qos.rate_limit)
  tags                  = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#__________________________________________________________________
#
# Intersight FC Zone Policies
# GUI Location: Configure > Policies > Create Policy > FC Zone
#__________________________________________________________________

module "fc_zone" {
  source  = "terraform-cisco-modules/policies-fc-zone/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "fc_zone", []) : v.name => v if lookup(
      local.modules.policies, "fc_zone", true
    )
  }
  fc_target_zoning_type = lookup(
    each.value, "fc_target_zoning_type", local.defaults.intersight.policies.fc_zone.fc_target_zoning_type
  )
  description  = lookup(each.value, "description", "")
  name         = "${each.value.name}${local.defaults.intersight.policies.fc_zone.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
  targets      = lookup(each.value, "targets", [])
}


#__________________________________________________________________
#
# Intersight Fibre Channel Adapter Policy
# GUI Location: Policies > Create Policy > Fibre Channel Adapter
#__________________________________________________________________

module "fibre_channel_adapter" {
  source  = "terraform-cisco-modules/policies-fibre-channel-adapter/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "fibre_channel_adapter", []) : v.name => v if lookup(
      local.modules.policies, "fibre_channel_adapter", true
    )
  }
  adapter_template                  = lookup(each.value, "adapter_template", "")
  description                       = lookup(each.value, "description", "")
  error_detection_timeout           = lookup(each.value, "error_detection_timeout", local.defaults.intersight.policies.fibre_channel_adapter.error_detection_timeout)
  enable_fcp_error_recovery         = lookup(each.value, "enable_fcp_error_recovery", local.defaults.intersight.policies.fibre_channel_adapter.enable_fcp_error_recovery)
  error_recovery_io_retry_timeout   = lookup(each.value, "error_recovery_io_retry_timeout", local.defaults.intersight.policies.fibre_channel_adapter.error_recovery_io_retry_timeout)
  error_recovery_link_down_timeout  = lookup(each.value, "error_recovery_link_down_timeout", local.defaults.intersight.policies.fibre_channel_adapter.error_recovery_link_down_timeout)
  error_recovery_port_down_io_retry = lookup(each.value, "error_recovery_port_down_io_retry", local.defaults.intersight.policies.fibre_channel_adapter.error_recovery_port_down_io_retry)
  error_recovery_port_down_timeout  = lookup(each.value, "error_recovery_port_down_timeout", local.defaults.intersight.policies.fibre_channel_adapter.error_recovery_port_down_timeout)
  flogi_retries                     = lookup(each.value, "flogi_retries", local.defaults.intersight.policies.fibre_channel_adapter.flogi_retries)
  flogi_timeout                     = lookup(each.value, "flogi_timeout", local.defaults.intersight.policies.fibre_channel_adapter.flogi_timeout)
  interrupt_mode                    = lookup(each.value, "interrupt_mode", local.defaults.intersight.policies.fibre_channel_adapter.interrupt_mode)
  io_throttle_count                 = lookup(each.value, "io_throttle_count", local.defaults.intersight.policies.fibre_channel_adapter.io_throttle_count)
  lun_queue_depth                   = lookup(each.value, "lun_queue_depth", local.defaults.intersight.policies.fibre_channel_adapter.lun_queue_depth)
  max_luns_per_target               = lookup(each.value, "max_luns_per_target", local.defaults.intersight.policies.fibre_channel_adapter.max_luns_per_target)
  name                              = "${each.value.name}${local.defaults.intersight.policies.fibre_channel_adapter.name_suffix}"
  organization                      = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  plogi_retries                     = lookup(each.value, "plogi_retries", local.defaults.intersight.policies.fibre_channel_adapter.plogi_retries)
  plogi_timeout                     = lookup(each.value, "plogi_timeout", local.defaults.intersight.policies.fibre_channel_adapter.plogi_timeout)
  receive_ring_size                 = lookup(each.value, "receive_ring_size", local.defaults.intersight.policies.fibre_channel_adapter.receive_ring_size)
  resource_allocation_timeout       = lookup(each.value, "resource_allocation_timeout", local.defaults.intersight.policies.fibre_channel_adapter.resource_allocation_timeout)
  scsi_io_queue_count               = lookup(each.value, "scsi_io_queue_count", local.defaults.intersight.policies.fibre_channel_adapter.scsi_io_queue_count)
  scsi_io_ring_size                 = lookup(each.value, "scsi_io_ring_size", local.defaults.intersight.policies.fibre_channel_adapter.scsi_io_ring_size)
  tags                              = lookup(each.value, "tags", local.defaults.intersight.tags)
  transmit_ring_size                = lookup(each.value, "transmit_ring_size", local.defaults.intersight.policies.fibre_channel_adapter.transmit_ring_size)
}


#__________________________________________________________________
#
# Intersight Fibre Channel Network Policy
# GUI Location: Policies > Create Policy > Fibre Channel Network
#__________________________________________________________________

module "fibre_channel_network" {
  source  = "terraform-cisco-modules/policies-fibre-channel-network/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "fibre_channel_network", []) : v.name => v if lookup(
      local.modules.policies, "fibre_channel_network", true
    )
  }
  default_vlan_id = lookup(
    each.value, "default_vlan_id", local.defaults.intersight.policies.fibre_channel_network.default_vlan_id
  )
  description  = lookup(each.value, "description", "")
  name         = "${each.value.name}${local.defaults.intersight.policies.fibre_channel_network.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
  vsan_id      = each.value.vsan_id
}


#__________________________________________________________________
#
# Intersight Fibre Channel QoS Policy
# GUI Location: Policies > Create Policy > Fibre Channel QoS
#__________________________________________________________________

module "fibre_channel_qos" {
  source  = "terraform-cisco-modules/policies-fibre-channel-qos/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "fibre_channel_qos", []) : v.name => v if lookup(
      local.modules.policies, "fibre_channel_qos", true
    )
  }
  burst       = lookup(each.value, "burst", local.defaults.intersight.policies.fibre_channel_qos.burst)
  cos         = lookup(each.value, "cos", local.defaults.intersight.policies.fibre_channel_qos.cos)
  description = lookup(each.value, "description", "")
  max_data_field_size = lookup(
    each.value, "max_data_field_size", local.defaults.intersight.policies.fibre_channel_qos.max_data_field_size
  )
  name         = "${each.value.name}${local.defaults.intersight.policies.fibre_channel_qos.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  rate_limit   = lookup(each.value, "rate_limit", local.defaults.intersight.policies.fibre_channel_qos.rate_limit)
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#__________________________________________________________________
#
# Intersight Flow Control Policy
# GUI Location: Policies > Create Policy > Flow Control
#__________________________________________________________________

module "flow_control" {
  source  = "terraform-cisco-modules/policies-flow-control/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "flow_control", []) : v.name => v if lookup(
      local.modules.policies, "flow_control", true
    )
  }
  description  = lookup(each.value, "description", "")
  name         = "${each.value.name}${local.defaults.intersight.policies.flow_control.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  priority     = lookup(each.value, "priority", local.defaults.intersight.policies.flow_control.priority)
  receive      = lookup(each.value, "receive", local.defaults.intersight.policies.flow_control.receive)
  send         = lookup(each.value, "send", local.defaults.intersight.policies.flow_control.send)
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#__________________________________________________________________
#
# Intersight IMC Access Policy
# GUI Location: Policies > Create Policy > IMC Access
#__________________________________________________________________

module "imc_access" {
  source  = "terraform-cisco-modules/policies-imc-access/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "imc_access", []) : v.name => v if lookup(
      local.modules.policies, "imc_access", true
    )
  }
  description = lookup(each.value, "description", "")
  inband_ip_pool = length(
    compact([lookup(each.value, "inband_ip_pool", "")])
  ) > 0 ? local.pools.ip[each.value.inband_ip_pool].moid : ""
  inband_vlan_id = lookup(
  each.value, "inband_vlan_id", local.defaults.intersight.policies.imc_access.inband_vlan_id)
  ipv4_address_configuration = lookup(
  each.value, "ipv4_address_configuration", local.defaults.intersight.policies.imc_access.ipv4_address_configuration)
  ipv6_address_configuration = lookup(
  each.value, "ipv6_address_configuration", local.defaults.intersight.policies.imc_access.ipv6_address_configuration)
  name         = "${each.value.name}${local.defaults.intersight.policies.imc_access.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  out_of_band_ip_pool = length(
    compact([lookup(each.value, "out_of_band_ip_pool", "")])
  ) > 0 ? local.pools.ip[each.value.out_of_band_ip_pool].moid : ""
  tags = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#____________________________________________________________________
#
# Intersight IPMI over LAN Policy
# GUI Location: Configure > Policies > Create Policy > IPMI over LAN
#____________________________________________________________________

module "ipmi_over_lan" {
  source  = "terraform-cisco-modules/policies-ipmi-over-lan/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "ipmi_over_lan", []) : v.name => v if lookup(
      local.modules.policies, "ipmi_over_lan", true
    )
  }
  description  = lookup(each.value, "description", "")
  enabled      = lookup(each.value, "enabled", local.defaults.intersight.policies.ipmi_over_lan.enabled)
  ipmi_key     = lookup(each.value, "ipmi_key", null)
  ipmi_key_1   = var.ipmi_key_1
  name         = "${each.value.name}${local.defaults.intersight.policies.ipmi_over_lan.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  privilege    = lookup(each.value, "privilege", local.defaults.intersight.policies.ipmi_over_lan.privilege)
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#__________________________________________________________________
#
# Intersight iSCSI Adapter Policy
# GUI Location: Policies > Create Policy > iSCSI Adapter
#__________________________________________________________________

module "iscsi_adapter" {
  source  = "terraform-cisco-modules/policies-iscsi-adapter/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "iscsi_adapter", []) : v.name => v if lookup(
      local.modules.policies, "iscsi_adapter", true
    )
  }
  description  = lookup(each.value, "description", "")
  dhcp_timeout = lookup(each.value, "dhcp_timeout", local.defaults.intersight.policies.iscsi_adapter.dhcp_timeout)
  lun_busy_retry_count = lookup(
    each.value, "lun_busy_retry_count", local.defaults.intersight.policies.iscsi_adapter.lun_busy_retry_count
  )
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
  tcp_connection_timeout = lookup(
    each.value, "tcp_connection_timeout", local.defaults.intersight.policies.iscsi_adapter.tcp_connection_timeout
  )
}


#__________________________________________________________________
#
# Intersight iSCSI Boot QoS Policy
# GUI Location: Policies > Create Policy > iSCSI Boot
#__________________________________________________________________

module "iscsi_boot" {
  depends_on = [
    module.iscsi_adapter,
    module.iscsi_static_target
  ]
  source  = "terraform-cisco-modules/policies-iscsi-boot/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "iscsi_boot", []) : v.name => v if lookup(
      local.modules.policies, "iscsi_boot", true
    )
  }
  authentication = lookup(
    each.value, "authentication", local.defaults.intersight.policies.iscsi_boot.authentication
  )
  description = lookup(each.value, "description", "")
  dhcp_vendor_id_iqn = lookup(
    each.value, "dhcp_vendor_id_iqn", local.defaults.intersight.policies.iscsi_boot.dhcp_vendor_id_iqn
  )
  initiator_ip_pool = length(
    compact([each.value.initiator_ip_pool])
  ) > 0 ? local.pools.ip[each.value.initiator_ip_pool].moid : ""
  initiator_ip_source = lookup(
    each.value, "initiator_ip_source", local.defaults.intersight.policies.iscsi_boot.initiator_ip_source
  )
  initiator_static_ip_v4_config = lookup(
    each.value, "initiator_static_ip_v4_config", []
  )
  iscsi_adapter_policy = length(compact([each.value.iscsi_adapter_policy])
  ) > 0 ? module.iscsi_adapter[each.value.iscsi_adapter_policy].moid : ""
  iscsi_boot_password = var.iscsi_boot_password
  name                = "${each.value.name}${local.defaults.intersight.policies.ethernet_qos.name_suffix}"
  organization        = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  primary_target_policy = length(
    compact([each.value.primary_target_policy])
  ) > 0 ? module.iscsi_static_target[each.value.primary_target_policy].moid : ""
  secondary_target_policy = length(
    compact([each.value.secondary_target_policy])
  ) > 0 ? module.iscsi_static_target[each.value.secondary_target_policy].moid : ""
  tags = lookup(each.value, "tags", local.defaults.intersight.tags)
  target_source_type = lookup(
    each.value, "target_source_type", local.defaults.intersight.policies.iscsi_boot.target_source_type
  )
  username = lookup(each.value, "username", "")
}


#__________________________________________________________________
#
# Intersight iSCSI Static Target Policy
# GUI Location: Policies > Create Policy > iSCSI Static Target
#__________________________________________________________________

module "iscsi_static_target" {
  source  = "terraform-cisco-modules/policies-iscsi-static-target/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "iscsi_static_target", []) : v.name => v if lookup(
      local.modules.policies, "iscsi_static_target", true
    )
  }
  description  = lookup(each.value, "description", "")
  ip_address   = each.value.ip_address
  lun          = lookup(each.value, "lun", [])
  name         = "${each.value.name}${local.defaults.intersight.policies.iscsi_static_target.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  port         = each.value.port
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
  target_name  = each.value.target_name
}


#_________________________________________________________________________
#
# Intersight LAN Connectivity
# GUI Location: Configure > Policies > Create Policy > LAN Connectivity
#_________________________________________________________________________

module "lan_connectivity" {
  depends_on = [
    module.ethernet_adapter,
    module.ethernet_network,
    module.ethernet_network_control,
    module.ethernet_network_group,
    module.ethernet_qos,
    module.iscsi_boot
  ]
  source  = "terraform-cisco-modules/policies-lan-connectivity/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "lan_connectivity", []) : v.name => v if lookup(
      local.modules.policies, "lan_connectivity", true
    )
  }
  description = lookup(each.value, "description", "")
  enable_azure_stack_host_qos = lookup(
    each.value, "enable_azure_stack_host_qos", local.defaults.intersight.policies.lan_connectivity.enable_azure_stack_host_qos
  )
  iqn_allocation_type = lookup(
    each.value, "iqn_allocation_type", local.defaults.intersight.policies.lan_connectivity.iqn_allocation_type
  )
  iqn_pool = length(compact([lookup(each.value, "iqn_pool", "")])) > 0 ? local.pools.iqn[each.value.iqn_pool].moid : ""
  iqn_static_identifier = lookup(
    each.value, "iqn_static_identifier", ""
  )
  name            = "${each.value.name}${local.defaults.intersight.policies.lan_connectivity.name_suffix}"
  organization    = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags            = lookup(each.value, "tags", local.defaults.intersight.tags)
  target_platform = lookup(each.value, "target_platform", local.defaults.intersight.policies.lan_connectivity.target_platform)
  vnic_placement_mode = lookup(
    each.value, "vnic_placement_mode", local.defaults.intersight.policies.lan_connectivity.vnic_placement_mode
  )
  vnics = [
    for v in lookup(each.value, "vnics", []) : {
      cdn_value       = lookup(v, "cdn_value", local.defaults.intersight.policies.lan_connectivity.vnics.cdn_value)
      enable_failover = lookup(v, "enable_failover", local.defaults.intersight.policies.lan_connectivity.vnics.enable_failover)
      ethernet_adapter_policy = module.ethernet_adapter[
        lookup(v, "ethernet_adapter_policy", local.defaults.intersight.policies.lan_connectivity.vnics.ethernet_adapter_policy)
      ].moid
      ethernet_network_control_policy = module.ethernet_network_control[
        lookup(v, "ethernet_network_control_policy", local.defaults.intersight.policies.lan_connectivity.vnics.ethernet_network_control_policy)
      ].moid
      ethernet_network_group_policy = length(compact([
        lookup(v, "ethernet_network_group_policy", local.defaults.intersight.policies.lan_connectivity.vnics.ethernet_network_group_policy)])
        ) > 0 ? module.ethernet_network_group[lookup(
        v, "ethernet_network_group_policy", local.defaults.intersight.policies.lan_connectivity.vnics.ethernet_network_group_policy)
      ].moid : ""
      ethernet_network_policy = length(compact([
        lookup(v, "ethernet_network_policy", local.defaults.intersight.policies.lan_connectivity.vnics.ethernet_network_policy)])
        ) > 0 ? module.ethernet_network[lookup(
        v, "ethernet_network_policy", local.defaults.intersight.policies.lan_connectivity.vnics.ethernet_network_policy)
      ].moid : ""
      ethernet_qos_policy = module.ethernet_qos[
        lookup(v, "ethernet_qos_policy", local.defaults.intersight.policies.lan_connectivity.vnics.ethernet_qos_policy)
      ].moid
      iscsi_boot_policy = length(compact([lookup(
        v, "iscsi_boot_policy", local.defaults.intersight.policies.lan_connectivity.vnics.iscsi_boot_policy)])
        ) > 0 ? module.iscsi_boot[length(compact([lookup(
          v, "iscsi_boot_policy", local.defaults.intersight.policies.lan_connectivity.vnics.iscsi_boot_policy)])
        )
      ].moid : ""
      mac_address_allocation_type = lookup(
        v, "mac_address_allocation_type", local.defaults.intersight.policies.lan_connectivity.vnics.mac_address_allocation_type
      )
      mac_address_pool = length(compact([
        lookup(v, "mac_address_pool", local.defaults.intersight.policies.lan_connectivity.vnics.mac_address_pool)])
        ) > 0 ? local.pools.mac[lookup(
        v, "mac_address_pool", local.defaults.intersight.policies.lan_connectivity.vnics.mac_address_pool)
      ].moid : ""
      mac_address_static = lookup(v, "mac_address_static", "")
      name               = v.name
      placement_pci_link = lookup(
        v, "placement_pci_link", local.defaults.intersight.policies.lan_connectivity.vnics.placement_pci_link
      )
      placement_pci_order = lookup(
        v, "placement_pci_order", local.defaults.intersight.policies.lan_connectivity.vnics.placement_pci_order
      )
      placement_slot_id = lookup(
        v, "placement_slot_id", local.defaults.intersight.policies.lan_connectivity.vnics.placement_slot_id
      )
      placement_switch_id = lookup(
        v, "placement_switch_id", local.defaults.intersight.policies.lan_connectivity.vnics.placement_switch_id
      )
      placement_uplink_port = lookup(
        v, "placement_uplink_port", local.defaults.intersight.policies.lan_connectivity.vnics.placement_uplink_port
      )
      usnic_adapter_policy = length(
        compact([lookup(v, "usnic_adapter_policy", "")])
      ) > 0 ? module.ethernet_adapter[v.usnic_adapter_policy].moid : ""
      usnic_class_of_service = lookup(
        v, "usnic_class_of_service", local.defaults.intersight.policies.lan_connectivity.vnics.usnic_class_of_service
      )
      usnic_number_of_usnics = lookup(
        v, "usnic_number_of_usnics", local.defaults.intersight.policies.lan_connectivity.vnics.usnic_number_of_usnics
      )
      vmq_enable_virtual_machine_multi_queue = lookup(
        v, "vmq_enable_virtual_machine_multi_queue", local.defaults.intersight.policies.lan_connectivity.vnics.vmq_enable_virtual_machine_multi_queue
      )
      vmq_enabled = lookup(
        v, "vmq_enabled", local.defaults.intersight.policies.lan_connectivity.vnics.vmq_enabled
      )
      vmq_number_of_interrupts = lookup(
        v, "vmq_number_of_interrupts", local.defaults.intersight.policies.lan_connectivity.vnics.vmq_number_of_interrupts
      )
      vmq_number_of_sub_vnics = lookup(
        v, "vmq_number_of_sub_vnics", local.defaults.intersight.policies.lan_connectivity.vnics.vmq_number_of_sub_vnics
      )
      vmq_number_of_virtual_machine_queues = lookup(
        v, "vmq_number_of_virtual_machine_queues", local.defaults.intersight.policies.lan_connectivity.vnics.vmq_number_of_virtual_machine_queues
      )
      vmq_vmmq_adapter_policy = length(
        compact([lookup(v, "vmq_vmmq_adapter_policy", "")])
      ) > 0 ? module.ethernet_adapter[v.vmq_vmmq_adapter_policy].moid : ""
    }
  ]
}


#__________________________________________________________________
#
# Intersight LDAP Policy
# GUI Location: Policies > Create Policy > LDAP
#__________________________________________________________________

module "ldap" {
  source  = "terraform-cisco-modules/policies-ldap/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "ldap", []) : v.name => v if lookup(
      local.modules.policies, "ldap", true
    )
  }
  base_settings = {
    base_dn = each.value.base_settings.base_dn
    domain  = each.value.base_settings.domain
    timeout = lookup(each.value.base_settings, "timeout", local.defaults.intersight.policies.ldap.base_settings.timeout)
  }
  binding_parameters = {
    bind_dn = lookup(
      each.value.binding_parameters, "bind_dn", local.defaults.intersight.policies.ldap.binding_parameters.bind_dn
    )
    bind_method = lookup(
      each.value.binding_parameters, "timeout", local.defaults.intersight.policies.ldap.binding_parameters.bind_method
    )
  }
  binding_parameters_password = var.binding_parameters_password
  description                 = lookup(each.value, "description", "")
  enable_encryption           = lookup(each.value, "enable_encryption", local.defaults.intersight.policies.ldap.enable_encryption)
  enable_group_authorization = lookup(
    each.value, "enable_group_authorization", local.defaults.intersight.policies.ldap.enable_group_authorization
  )
  enable_ldap = lookup(each.value, "enable_ldap", local.defaults.intersight.policies.ldap.enable_ldap)
  ldap_from_dns = {
    enable = lookup(
      each.value.ldap_from_dns, "enable", local.defaults.intersight.policies.ldap.ldap_from_dns.enable
    )
    search_domain = lookup(
      each.value.ldap_from_dns, "search_domain", local.defaults.intersight.policies.ldap.ldap_from_dns.search_domain
    )
    search_forest = lookup(
      each.value.ldap_from_dns, "search_forest", local.defaults.intersight.policies.ldap.ldap_from_dns.search_forest
    )
    source = lookup(
      each.value.ldap_from_dns, "source", local.defaults.intersight.policies.ldap.ldap_from_dns.source
    )
  }
  ldap_groups  = lookup(each.value, "ldap_groups", [])
  ldap_servers = lookup(each.value, "ldap_servers", [])
  name         = "${each.value.name}${local.defaults.intersight.policies.ldap.name_suffix}"
  nested_group_search_depth = lookup(
    each.value, "nested_group_search_depth", local.defaults.intersight.policies.ldap.nested_group_search_depth
  )
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  search_parameters = {
    attribute = lookup(
      each.value.search_parameters, "attribute", local.defaults.intersight.policies.ldap.search_parameters.attribute
    )
    filter = lookup(
      each.value.search_parameters, "filter", local.defaults.intersight.policies.ldap.search_parameters.filter
    )
    group_attribute = lookup(
      each.value.search_parameters, "group_attribute", local.defaults.intersight.policies.ldap.search_parameters.group_attribute
    )
  }
  tags = lookup(each.value, "tags", local.defaults.intersight.tags)
  user_search_precedence = lookup(
    each.value, "user_search_precedence", local.defaults.intersight.policies.ldap.user_search_precedence
  )
}


#__________________________________________________________________
#
# Intersight Link Aggregation Policy
# GUI Location: Policies > Create Policy > Link Aggregation
#__________________________________________________________________

module "link_aggregation" {
  source  = "terraform-cisco-modules/policies-link-aggregation/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "link_aggregation", []) : v.name => v if lookup(
      local.modules.policies, "link_aggregation", true
    )
  }
  description  = lookup(each.value, "description", "")
  lacp_rate    = lookup(each.value, "lacp_rate", local.defaults.intersight.policies.link_aggregation.lacp_rate)
  name         = "${each.value.name}${local.defaults.intersight.policies.link_aggregation.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  suspend_individual = lookup(
    each.value, "suspend_individual", local.defaults.intersight.policies.link_aggregation.suspend_individual
  )
  tags = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#__________________________________________________________________
#
# Intersight Link Control Policy
# GUI Location: Policies > Create Policy > Link Control
#__________________________________________________________________

module "link_control" {
  source  = "terraform-cisco-modules/policies-link-control/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "link_control", []) : v.name => v if lookup(
      local.modules.policies, "link_control", true
    )
  }
  admin_state  = lookup(each.value, "admin_state", local.defaults.intersight.policies.link_control.admin_state)
  description  = lookup(each.value, "description", "")
  mode         = lookup(each.value, "mode", local.defaults.intersight.policies.link_control.mode)
  name         = "${each.value.name}${local.defaults.intersight.policies.link_control.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#__________________________________________________________________
#
# Intersight Local User Policy
# GUI Location: Policies > Create Policy > Local User
#__________________________________________________________________

module "local_user" {
  source  = "terraform-cisco-modules/policies-local-user/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "local_user", []) : v.name => v if lookup(
      local.modules.policies, "local_user", true
    )
  }
  always_send_user_password = lookup(
    each.value, "always_send_user_password", local.defaults.intersight.policies.local_user.always_send_user_password
  )
  description = lookup(each.value, "description", "")
  enable_password_expiry = lookup(
    each.value, "enable_password_expiry", local.defaults.intersight.policies.local_user.enable_password_expiry
  )
  enforce_strong_password = lookup(
    each.value, "enforce_strong_password", local.defaults.intersight.policies.local_user.enforce_strong_password
  )
  grace_period          = lookup(each.value, "grace_period", local.defaults.intersight.policies.local_user.grace_period)
  local_user_password_1 = var.local_user_password_1
  local_user_password_2 = var.local_user_password_2
  local_user_password_3 = var.local_user_password_3
  local_user_password_4 = var.local_user_password_4
  local_user_password_5 = var.local_user_password_5
  name                  = "${each.value.name}${local.defaults.intersight.policies.local_user.name_suffix}"
  notification_period = lookup(
    each.value, "notification_period", local.defaults.intersight.policies.local_user.notification_period
  )
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  password_expiry_duration = lookup(
    each.value, "password_expiry_duration", local.defaults.intersight.policies.local_user.password_expiry_duration
  )
  password_history = lookup(
    each.value, "password_history", local.defaults.intersight.policies.local_user.password_history
  )
  tags  = lookup(each.value, "tags", local.defaults.intersight.tags)
  users = lookup(each.value, "users", [])
}


#__________________________________________________________________
#
# Intersight Multicast Policy
# GUI Location: Policies > Create Policy > Multicast
#__________________________________________________________________

module "multicast" {
  source  = "terraform-cisco-modules/policies-multicast/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "multicast", []) : v.name => v if lookup(
      local.modules.policies, "multicast", true
    )
  }
  description  = lookup(each.value, "description", "")
  name         = "${each.value.name}${local.defaults.intersight.policies.multicast.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  querier_ip_address = lookup(
    each.value, "querier_ip_address", local.defaults.intersight.policies.multicast.querier_ip_address
  )
  querier_ip_address_peer = lookup(
    each.value, "querier_ip_address_peer", local.defaults.intersight.policies.multicast.querier_ip_address_peer
  )
  querier_state  = lookup(each.value, "querier_state", local.defaults.intersight.policies.multicast.querier_state)
  snooping_state = lookup(each.value, "snooping_state", local.defaults.intersight.policies.multicast.snooping_state)
  tags           = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#__________________________________________________________________
#
# Intersight Network Connectivity Policy
# GUI Location: Policies > Create Policy > Network Connectivity
#__________________________________________________________________

module "network_connectivity" {
  source  = "terraform-cisco-modules/policies-network-connectivity/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "network_connectivity", []) : v.name => v if lookup(
      local.modules.policies, "network_connectivity", true
    )
  }
  description = lookup(each.value, "description", "")
  dns_servers_v4 = lookup(
    each.value, "dns_servers_v4", local.defaults.intersight.policies.network_connectivity.dns_servers_v4
  )
  dns_servers_v6 = lookup(
    each.value, "dns_servers_v6", local.defaults.intersight.policies.network_connectivity.dns_servers_v6
  )
  enable_dynamic_dns = lookup(
    each.value, "enable_dynamic_dns", local.defaults.intersight.policies.network_connectivity.enable_dynamic_dns
  )
  enable_ipv6 = lookup(
    each.value, "enable_ipv6", local.defaults.intersight.policies.network_connectivity.enable_ipv6
  )
  name = "${each.value.name}${local.defaults.intersight.policies.network_connectivity.name_suffix}"
  obtain_ipv4_dns_from_dhcp = lookup(
    each.value, "obtain_ipv4_dns_from_dhcp", local.defaults.intersight.policies.network_connectivity.obtain_ipv4_dns_from_dhcp
  )
  obtain_ipv6_dns_from_dhcp = lookup(
    each.value, "obtain_ipv6_dns_from_dhcp", local.defaults.intersight.policies.network_connectivity.obtain_ipv6_dns_from_dhcp
  )
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  profiles = [
    for v in local.domains : {
      name        = v.moid
      object_type = "fabric.SwitchProfile"
      } if length(regexall(v.name, v.network_connectivity_policy)) > 0 || length(regexall(
      v.network_connectivity_policy, "${each.value.name}${local.defaults.intersight.policies.network_connectivity.name_suffix}")
    ) > 0
  ]
  tags          = lookup(each.value, "tags", local.defaults.intersight.tags)
  update_domain = lookup(each.value, "update_domain", local.defaults.intersight.policies.network_connectivity.update_domain)
}


#__________________________________________________________________
#
# Intersight NTP Policy
# GUI Location: Policies > Create Policy > NTP
#__________________________________________________________________

module "ntp" {
  source  = "terraform-cisco-modules/policies-ntp/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "ntp", []) : v.name => v if lookup(
      local.modules.policies, "ntp", true
    )
  }
  description  = lookup(each.value, "description", "")
  enabled      = lookup(each.value, "enabled", local.defaults.intersight.policies.ntp.enabled)
  name         = "${each.value.name}${local.defaults.intersight.policies.ntp.name_suffix}"
  ntp_servers  = lookup(each.value, "ntp_servers", local.defaults.intersight.policies.ntp.ntp_servers)
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  profiles = [
    for v in local.domains : {
      name        = v.moid
      object_type = "fabric.SwitchProfile"
      } if length(regexall(each.value.name, v.ntp_policy)) > 0 || length(regexall(
      v.ntp_policy, "${each.value.name}${local.defaults.intersight.policies.ntp.name_suffix}")
    ) > 0
  ]
  tags     = lookup(each.value, "tags", local.defaults.intersight.tags)
  timezone = lookup(each.value, "timezone", local.defaults.intersight.policies.ntp.timezone)
}


#__________________________________________________________________
#
# Intersight Port Policy
# GUI Location: Policies > Create Policy > Port
#__________________________________________________________________

module "port" {
  depends_on = [
    module.ethernet_network_control,
    module.ethernet_network_group,
  ]
  source  = "terraform-cisco-modules/policies-port/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "port", []) : v.name => v if lookup(
      local.modules.policies, "port", true
    )
  }
  description  = lookup(each.value, "description", "")
  device_model = lookup(each.value, "device_model", local.defaults.intersight.policies.port.device_model)
  name         = "${each.value.name}${local.defaults.intersight.policies.port.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  port_channel_appliances = [
    for v in lookup(each.value, "port_channel_appliances", []) : {
      admin_speed = lookup(v, "admin_speed", local.defaults.intersight.policies.port.port_channel_appliances.admin_speed)
      ethernet_network_control_policy = module.ethernet_network_control[
        lookup(v, "ethernet_network_control_policy", local.defaults.intersight.policies.port.port_channel_appliances.ethernet_network_control_policy)
      ].moid
      ethernet_network_group_policy = module.ethernet_network_group[
        lookup(v, "ethernet_network_group_policy", local.defaults.intersight.policies.port.port_channel_appliances.ethernet_network_group_policy)
      ].moid
      interfaces = lookup(v, "interfaces", [])
      mode       = lookup(v, "mode", local.defaults.intersight.policies.port.port_channel_appliances.mode)
      pc_id      = v.pc_id
      priority   = lookup(v, "priority", local.defaults.intersight.policies.port.port_channel_appliances.priority)
    }
  ]
  port_channel_ethernet_uplinks = [
    for v in lookup(each.value, "port_channel_ethernet_uplinks", []) : {
      admin_speed = lookup(v, "admin_speed", local.defaults.intersight.policies.port.port_channel_ethernet_uplinks.admin_speed)
      ethernet_network_group_policy = length(compact([
        lookup(v, "ethernet_network_group_policy", local.defaults.intersight.policies.port.port_channel_ethernet_uplinks.ethernet_network_group_policy)
        ])) > 0 ? module.ethernet_network_group[
        lookup(v, "ethernet_network_group_policy", local.defaults.intersight.policies.port.port_channel_ethernet_uplinks.ethernet_network_group_policy)
      ].moid : ""
      flow_control_policy = length(compact([
        lookup(v, "flow_control_policy", local.defaults.intersight.policies.port.port_channel_ethernet_uplinks.ethernet_network_group_policy)
        ])) > 0 ? module.flow_control[
        lookup(v, "flow_control_policy", local.defaults.intersight.policies.port.port_channel_ethernet_uplinks.flow_control_policy)
      ].moid : ""
      interfaces = lookup(v, "interfaces", [])
      link_aggregation_policy = length(compact([
        lookup(v, "link_aggregation_policy", local.defaults.intersight.policies.port.port_channel_ethernet_uplinks.ethernet_network_group_policy)
        ])) > 0 ? module.link_aggregation[
        lookup(v, "link_aggregation_policy", local.defaults.intersight.policies.port.port_channel_ethernet_uplinks.link_aggregation_policy)
      ].moid : ""
      link_control_policy = length(compact([
        lookup(v, "link_control_policy", local.defaults.intersight.policies.port.port_channel_ethernet_uplinks.ethernet_network_group_policy)
        ])) > 0 ? module.link_control[
        lookup(v, "link_control_policy", local.defaults.intersight.policies.port.port_channel_ethernet_uplinks.link_control_policy)
      ].moid : ""
      pc_id = v.pc_id
    }
  ]
  port_channel_fc_uplinks = [
    for v in lookup(each.value, "port_channel_fc_uplinks", []) : {
      admin_speed  = lookup(v, "admin_speed", local.defaults.intersight.policies.port.port_channel_fc_uplinks.admin_speed)
      fill_pattern = lookup(v, "fill_pattern", local.defaults.intersight.policies.port.port_channel_fc_uplinks.fill_pattern)
      interfaces   = lookup(v, "interfaces", [])
      pc_id        = v.pc_id
      vsan_id      = v.vsan_id
    }
  ]
  port_channel_fcoe_uplinks = [
    for v in lookup(each.value, "port_channel_fcoe_uplinks", []) : {
      admin_speed = lookup(v, "admin_speed", local.defaults.intersight.policies.port.port_channel_fcoe_uplinks.admin_speed)
      interfaces  = lookup(v, "interfaces", [])
      link_aggregation_policy = length(compact([
        lookup(v, "link_aggregation_policy", local.defaults.intersight.policies.port.port_channel_fcoe_uplinks.ethernet_network_group_policy)
        ])) > 0 ? module.link_aggregation[
        lookup(v, "link_aggregation_policy", local.defaults.intersight.policies.port.port_channel_fcoe_uplinks.link_aggregation_policy)
      ].moid : ""
      link_control_policy = length(compact([
        lookup(v, "link_control_policy", local.defaults.intersight.policies.port.port_channel_fcoe_uplinks.ethernet_network_group_policy)
        ])) > 0 ? module.link_control[
        lookup(v, "link_control_policy", local.defaults.intersight.policies.port.port_channel_fcoe_uplinks.link_control_policy)
      ].moid : ""
      pc_id = v.pc_id
    }
  ]
  port_modes = [
    for v in lookup(each.value, "port_modes", []) : {
      custom_mode = lookup(v, "custom_mode", local.defaults.intersight.policies.port.port_modes.custom_mode)
      port_list   = v.port_list
      slot_id     = lookup(v, "slot_id", 1)
    }
  ]
  port_role_appliances = [
    for v in lookup(each.value, "port_role_appliances", []) : {
      admin_speed      = lookup(v, "admin_speed", local.defaults.intersight.policies.port.port_role_appliances.admin_speed)
      breakout_port_id = lookup(v, "breakout_port_id", 0)
      ethernet_network_control_policy = module.ethernet_network_control[
        lookup(v, "ethernet_network_control_policy", local.defaults.intersight.policies.port.port_role_appliances.ethernet_network_control_policy)
      ].moid
      ethernet_network_group_policy = module.ethernet_network_group[
        lookup(v, "ethernet_network_group_policy", local.defaults.intersight.policies.port.port_role_appliances.ethernet_network_group_policy)
      ].moid
      fec       = lookup(v, "fec", local.defaults.intersight.policies.port.port_role_appliances.fec)
      mode      = lookup(v, "mode", local.defaults.intersight.policies.port.port_role_appliances.mode)
      port_list = v.port_list
      priority  = lookup(v, "priority", local.defaults.intersight.policies.port.port_role_appliances.priority)
      slot_id   = lookup(v, "slot_id", 0)
    }
  ]
  port_role_ethernet_uplinks = [
    for v in lookup(each.value, "port_role_ethernet_uplinks", []) : {
      admin_speed      = lookup(v, "admin_speed", local.defaults.intersight.policies.port.port_role_ethernet_uplinks.admin_speed)
      breakout_port_id = lookup(v, "breakout_port_id", 0)
      ethernet_network_group_policy = length(compact([
        lookup(v, "ethernet_network_group_policy", local.defaults.intersight.policies.port.port_role_ethernet_uplinks.ethernet_network_group_policy)
        ])) > 0 ? module.ethernet_network_group[
        lookup(v, "ethernet_network_group_policy", local.defaults.intersight.policies.port.port_role_ethernet_uplinks.ethernet_network_group_policy)
      ].moid : ""
      fec = lookup(v, "fec", local.defaults.intersight.policies.port.port_role_ethernet_uplinks.fec)
      flow_control_policy = length(compact([
        lookup(v, "flow_control_policy", local.defaults.intersight.policies.port.port_role_ethernet_uplinks.ethernet_network_group_policy)
        ])) > 0 ? module.flow_control[
        lookup(v, "flow_control_policy", local.defaults.intersight.policies.port.port_role_ethernet_uplinks.flow_control_policy)
      ].moid : ""
      link_control_policy = length(compact([
        lookup(v, "link_control_policy", local.defaults.intersight.policies.port.port_role_ethernet_uplinks.ethernet_network_group_policy)
        ])) > 0 ? module.link_control[
        lookup(v, "link_control_policy", local.defaults.intersight.policies.port.port_role_ethernet_uplinks.link_control_policy)
      ].moid : ""
      port_list = v.port_list
      slot_id   = lookup(v, "slot_id", 0)
    }
  ]
  port_role_fc_storage = [
    for v in lookup(each.value, "port_role_fc_storage", []) : {
      admin_speed      = lookup(v, "admin_speed", local.defaults.intersight.policies.port.port_role_fc_storage.admin_speed)
      breakout_port_id = lookup(v, "breakout_port_id", 0)
      port_list        = v.port_list
      slot_id          = lookup(v, "slot_id", 0)
      vsan_id          = v.vsan_id
    }
  ]
  port_role_fc_uplinks = [
    for v in lookup(each.value, "port_role_fc_uplinks", []) : {
      admin_speed      = lookup(v, "admin_speed", local.defaults.intersight.policies.port.port_role_fc_uplinks.admin_speed)
      breakout_port_id = lookup(v, "breakout_port_id", 0)
      fill_pattern     = lookup(v, "fill_pattern", local.defaults.intersight.policies.port.port_role_fc_uplinks.fill_pattern)
      port_list        = v.port_list
      slot_id          = lookup(v, "slot_id", 0)
      vsan_id          = v.vsan_id
    }
  ]
  port_role_fcoe_uplinks = [
    for v in lookup(each.value, "port_role_fcoe_uplinks", []) : {
      admin_speed      = lookup(v, "admin_speed", local.defaults.intersight.policies.port.port_role_fcoe_uplinks.admin_speed)
      breakout_port_id = lookup(v, "breakout_port_id", 0)
      interfaces       = lookup(v, "interfaces", [])
      fec              = lookup(v, "fec", local.defaults.intersight.policies.port.port_role_fcoe_uplinks.fec)
      link_control_policy = length(compact([
        lookup(v, "link_control_policy", local.defaults.intersight.policies.port.port_role_fcoe_uplinks.ethernet_network_group_policy)
        ])) > 0 ? module.link_control[
        lookup(v, "link_control_policy", local.defaults.intersight.policies.port.port_role_fcoe_uplinks.link_control_policy)
      ].moid : ""
      port_list = v.port_list
      slot_id   = lookup(v, "slot_id", 0)
    }
  ]
  port_role_servers = [
    for v in lookup(each.value, "port_channel_fcoe_uplinks", []) : {
      breakout_port_id = lookup(v, "breakout_port_id", 0)
      port_list        = v.port_list
      slot_id          = lookup(v, "slot_id", 0)
    }
  ]
  profiles = [
    for v in local.domains : v.moid if length(regexall(v.name, v.port_policy)) > 0 || length(regexall(
      v.port_policy, "${each.value.name}${local.defaults.intersight.policies.port.name_suffix}")
    ) > 0
  ]
  tags = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#__________________________________________________________________
#
# Intersight Power Policy
# GUI Location: Policies > Create Policy > Power
#__________________________________________________________________

module "power" {
  source  = "terraform-cisco-modules/policies-power/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "power", []) : v.name => v if lookup(
      local.modules.policies, "power", true
    )
  }
  description = lookup(each.value, "description", "")
  dynamic_power_rebalancing = lookup(
    each.value, "dynamic_power_rebalancing", local.defaults.intersight.policies.power.dynamic_power_rebalancing
  )
  name             = "${each.value.name}${local.defaults.intersight.policies.power.name_suffix}"
  organization     = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  power_allocation = lookup(each.value, "power_allocation", local.defaults.intersight.policies.power.power_allocation)
  power_priority   = lookup(each.value, "power_priority", local.defaults.intersight.policies.power.power_priority)
  power_profiling  = lookup(each.value, "power_profiling", local.defaults.intersight.policies.power.power_profiling)
  power_redunancy  = lookup(each.value, "power_redunancy", local.defaults.intersight.policies.power.power_redunancy)
  power_restore    = lookup(each.value, "power_restore", local.defaults.intersight.policies.power.power_restore)
  power_save_mode  = lookup(each.value, "power_save_mode", local.defaults.intersight.policies.power.power_save_mode)
  tags             = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#_________________________________________________________________________
#
# Intersight SAN Connectivity
# GUI Location: Configure > Policies > Create Policy > SAN Connectivity
#_________________________________________________________________________

module "san_connectivity" {
  depends_on = [
    module.fc_zone,
    module.fibre_channel_adapter,
    module.fibre_channel_network,
    module.fibre_channel_qos
  ]
  source  = "terraform-cisco-modules/policies-san-connectivity/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "san_connectivity", []) : v.name => v if lookup(
      local.modules.policies, "san_connectivity", true
    )
  }
  description         = lookup(each.value, "description", "")
  name                = "${each.value.name}${local.defaults.intersight.policies.san_connectivity.name_suffix}"
  organization        = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags                = lookup(each.value, "tags", local.defaults.intersight.tags)
  target_platform     = lookup(each.value, "target_platform", local.defaults.intersight.policies.san_connectivity.target_platform)
  vhba_placement_mode = lookup(each.value, "vhba_placement_mode", local.defaults.intersight.policies.san_connectivity.vhba_placement_mode)
  vhbas = [
    for v in lookup(each.value, "vhbas", []) : {
      fc_zone_policies = length(lookup(
        v, "fc_zone_policies", local.defaults.intersight.policies.san_connectivity.vhbas.fc_zone_policies)
      ) > 0 ? [for s in v.fc_zone_policies : module.fc_zone[s].moid] : []
      fibre_channel_adapter_policy = module.fibre_channel_adapter[lookup(
        v, "fibre_channel_adapter_policy", local.defaults.intersight.policies.san_connectivity.vhbas.fibre_channel_adapter_policy
      )].moid
      fibre_channel_network_policy = module.fibre_channel_network[lookup(
        v, "fibre_channel_network_policy", local.defaults.intersight.policies.san_connectivity.vhbas.fibre_channel_network_policy
      )].moid
      fibre_channel_qos_policy = module.fibre_channel_qos[lookup(
        v, "fibre_channel_qos_policy", local.defaults.intersight.policies.san_connectivity.vhbas.fibre_channel_qos_policy
      )].moid
      name                    = v.name
      persistent_lun_bindings = lookup(v, "persistent_lun_bindings", local.defaults.intersight.policies.san_connectivity.vhbas.persistent_lun_bindings)
      placement_pci_link      = lookup(v, "placement_pci_link", local.defaults.intersight.policies.san_connectivity.vhbas.placement_pci_link)
      placement_pci_order     = lookup(v, "placement_pci_order", local.defaults.intersight.policies.san_connectivity.vhbas.placement_pci_order)
      placement_slot_id       = lookup(v, "placement_slot_id", local.defaults.intersight.policies.san_connectivity.vhbas.placement_slot_id)
      placement_switch_id     = v.placement_switch_id
      placement_uplink_port   = lookup(v, "placement_uplink_port", local.defaults.intersight.policies.san_connectivity.vhbas.placement_uplink_port)
      vhba_type               = lookup(v, "vhba_type", local.defaults.intersight.policies.san_connectivity.vhbas.vhba_type)
      wwpn_allocation_type    = lookup(v, "wwpn_allocation_type", local.defaults.intersight.policies.san_connectivity.vhbas.wwpn_allocation_type)
      wwpn_pool               = length(compact([lookup(v, "wwpn_pool", "")])) > 0 ? local.pools.wwpn[v.wwpn_pool].moid : ""
      wwpn_static_address     = lookup(v, "wwpn_static_address", "")
    }
  ]
  wwnn_allocation_type = lookup(each.value, "wwnn_allocation_type", local.defaults.intersight.policies.san_connectivity.wwnn_allocation_type)
  wwnn_pool            = length(compact([lookup(each.value, "wwnn_pool", "")])) > 0 ? local.pools.wwnn[each.value.wwnn_pool].moid : ""
  wwnn_static_address  = lookup(each.value, "wwnn_static_address", "")
}


#__________________________________________________________________
#
# Intersight SD Card Policy
# GUI Location: Policies > Create Policy > SD Card
#__________________________________________________________________

module "sd_card" {
  source  = "terraform-cisco-modules/policies-sd-card/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "sd_card", []) : v.name => v if lookup(
      local.modules.policies, "sd_card", true
    )
  }
  description = lookup(each.value, "description", "")
  enable_diagnostics = lookup(
    each.value, "enable_diagnostics", local.defaults.intersight.policies.sd_card.enable_diagnostics
  )
  enable_drivers = lookup(each.value, "enable_drivers", local.defaults.intersight.policies.sd_card.enable_drivers)
  enable_huu     = lookup(each.value, "enable_huu", local.defaults.intersight.policies.sd_card.enable_huu)
  enable_os      = lookup(each.value, "enable_os", local.defaults.intersight.policies.sd_card.enable_os)
  enable_scu     = lookup(each.value, "enable_scu", local.defaults.intersight.policies.sd_card.enable_scu)
  name           = "${each.value.name}${local.defaults.intersight.policies.sd_card.name_suffix}"
  organization   = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags           = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#_________________________________________________________________________
#
# Intersight Serial over LAN Policy
# GUI Location: Configure > Policies > Create Policy > Serial over LAN
#_________________________________________________________________________

module "serial_over_lan" {
  source  = "terraform-cisco-modules/policies-serial-over-lan/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "serial_over_lan", []) : v.name => v if lookup(
      local.modules.policies, "serial_over_lan", true
    )
  }
  baud_rate    = lookup(each.value, "baud_rate", local.defaults.intersight.policies.serial_over_lan.baud_rate)
  com_port     = lookup(each.value, "com_port", local.defaults.intersight.policies.serial_over_lan.com_port)
  description  = lookup(each.value, "description", "")
  enabled      = lookup(each.value, "enabled", local.defaults.intersight.policies.serial_over_lan.enabled)
  name         = "${each.value.name}${local.defaults.intersight.policies.serial_over_lan.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  ssh_port     = lookup(each.value, "ssh_port", local.defaults.intersight.policies.serial_over_lan.ssh_port)
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#_________________________________________________________________________
#
# Intersight SMTP Policy
# GUI Location: Configure > Policies > Create Policy > SMTP
#_________________________________________________________________________

module "smtp" {
  source  = "terraform-cisco-modules/policies-smtp/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "smtp", []) : v.name => v if lookup(
      local.modules.policies, "smtp", true
    )
  }
  description = lookup(each.value, "description", "")
  enable_smtp = lookup(each.value, "enable_smtp", local.defaults.intersight.policies.smtp.enable_smtp)
  mail_alert_recipients = lookup(
    each.value, "mail_alert_recipients", local.defaults.intersight.policies.smtp.mail_alert_recipients
  )
  minimum_severity = lookup(each.value, "minimum_severity", local.defaults.intersight.policies.smtp.minimum_severity)
  name             = "${each.value.name}${local.defaults.intersight.policies.smtp.name_suffix}"
  organization     = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  smtp_alert_sender_address = lookup(
    each.value, "smtp_alert_sender_address", local.defaults.intersight.policies.smtp.smtp_alert_sender_address
  )
  smtp_port           = lookup(each.value, "smtp_port", local.defaults.intersight.policies.smtp.smtp_port)
  smtp_server_address = each.value.smtp_server_address
  tags                = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#_________________________________________________________________________
#
# Intersight SNNMP Policy
# GUI Location: Configure > Policies > Create Policy > SNMP
#_________________________________________________________________________

module "snmp" {
  source  = "terraform-cisco-modules/policies-snmp/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "snmp", []) : v.name => v if lookup(
      local.modules.policies, "snmp", true
    )
  }
  access_community_string   = lookup(each.value, "access_community_string", 0)
  access_community_string_1 = var.access_community_string_1
  access_community_string_2 = var.access_community_string_2
  access_community_string_3 = var.access_community_string_3
  access_community_string_4 = var.access_community_string_4
  access_community_string_5 = var.access_community_string_5
  description               = lookup(each.value, "description", "")
  enable_snmp               = lookup(each.value, "enable_snmp", local.defaults.intersight.policies.snmp.enable_snmp)
  name                      = "${each.value.name}${local.defaults.intersight.policies.snmp.name_suffix}"
  organization              = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  profiles = [
    for v in local.domains : {
      name        = v.moid
      object_type = "fabric.SwitchProfile"
      } if length(regexall(v.name, v.snmp_policy)) > 0 || length(regexall(
      v.snmp_policy, "${each.value.name}${local.defaults.intersight.policies.snmp.name_suffix}")
    ) > 0
  ]
  snmp_auth_password_1  = var.snmp_auth_password_1
  snmp_auth_password_2  = var.snmp_auth_password_2
  snmp_auth_password_3  = var.snmp_auth_password_3
  snmp_auth_password_4  = var.snmp_auth_password_4
  snmp_auth_password_5  = var.snmp_auth_password_5
  snmp_community_access = lookup(each.value, "snmp_community_access", local.defaults.intersight.policies.snmp.snmp_community_access)
  snmp_engine_input_id = lookup(
    each.value, "snmp_engine_input_id", local.defaults.intersight.policies.snmp.snmp_engine_input_id
  )
  snmp_port               = lookup(each.value, "snmp_port", local.defaults.intersight.policies.snmp.snmp_port)
  snmp_privacy_password_1 = var.snmp_privacy_password_1
  snmp_privacy_password_2 = var.snmp_privacy_password_2
  snmp_privacy_password_3 = var.snmp_privacy_password_3
  snmp_privacy_password_4 = var.snmp_privacy_password_4
  snmp_privacy_password_5 = var.snmp_privacy_password_5
  snmp_trap_community_1   = var.snmp_trap_community_1
  snmp_trap_community_2   = var.snmp_trap_community_2
  snmp_trap_community_3   = var.snmp_trap_community_3
  snmp_trap_community_4   = var.snmp_trap_community_4
  snmp_trap_community_5   = var.snmp_trap_community_5
  snmp_trap_destinations  = lookup(each.value, "snmp_trap_destinations", [])
  snmp_users              = lookup(each.value, "snmp_users", [])
  system_contact          = lookup(each.value, "system_contact", local.defaults.intersight.policies.snmp.system_contact)
  system_location         = lookup(each.value, "system_location", local.defaults.intersight.policies.snmp.system_location)
  tags                    = lookup(each.value, "tags", local.defaults.intersight.tags)
  trap_community_string   = lookup(each.value, "trap_community_string", 0)
}


#_________________________________________________________________________
#
# Intersight SSH Policy
# GUI Location: Configure > Policies > Create Policy > SSH
#_________________________________________________________________________

module "ssh" {
  source  = "terraform-cisco-modules/policies-ssh/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "ssh", []) : v.name => v if lookup(
      local.modules.policies, "ssh", true
    )
  }
  description  = lookup(each.value, "description", "")
  enable_ssh   = lookup(each.value, "enable_ssh", local.defaults.intersight.policies.ssh.enable_ssh)
  name         = "${each.value.name}${local.defaults.intersight.policies.ssh.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  ssh_port     = lookup(each.value, "ssh_port", local.defaults.intersight.policies.ssh.ssh_port)
  ssh_timeout  = lookup(each.value, "ssh_timeout", local.defaults.intersight.policies.ssh.ssh_timeout)
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#_________________________________________________________________________
#
# Intersight Storage Policy
# GUI Location: Configure > Policies > Create Policy > Storage
#_________________________________________________________________________

module "storage" {
  source  = "terraform-cisco-modules/policies-storage/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "storage", []) : v.name => v if lookup(
      local.modules.policies, "storage", true
    )
  }
  description       = lookup(each.value, "description", "")
  drive_groups      = lookup(each.value, "drive_groups", [])
  global_hot_spares = lookup(each.value, "global_hot_spares", local.defaults.intersight.policies.storage.global_hot_spares)
  m2_configuration  = lookup(each.value, "m2_configuration", [])
  name              = "${each.value.name}${local.defaults.intersight.policies.storage.name_suffix}"
  organization      = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  single_drive_raid_configuration = lookup(
    each.value, "single_drive_raid_configuration", []
  )
  tags               = lookup(each.value, "tags", local.defaults.intersight.tags)
  unused_disks_state = lookup(each.value, "unused_disks_state", local.defaults.intersight.policies.storage.unused_disks_state)
  use_jbod_for_vd_creation = lookup(
    each.value, "use_jbod_for_vd_creation", local.defaults.intersight.policies.storage.use_jbod_for_vd_creation
  )
}


#_________________________________________________________________________
#
# Intersight Switch Control Policy
# GUI Location: Configure > Policies > Create Policy > Switch Control
#_________________________________________________________________________

module "switch_control" {
  source  = "terraform-cisco-modules/policies-switch-control/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "switch_control", []) : v.name => v if lookup(
      local.modules.policies, "switch_control", true
    )
  }
  description = lookup(each.value, "description", "")
  ethernet_switching_mode = lookup(
    each.value, "ethernet_switching_mode", local.defaults.intersight.policies.switch_control.ethernet_switching_mode
  )
  fc_switching_mode = lookup(
    each.value, "fc_switching_mode", local.defaults.intersight.policies.switch_control.fc_switching_mode
  )
  mac_address_table_aging = lookup(
    each.value, "mac_address_table_aging", local.defaults.intersight.policies.switch_control.mac_address_table_aging
  )
  mac_aging_time = lookup(each.value, "mac_aging_time", local.defaults.intersight.policies.switch_control.mac_aging_time)
  name           = "${each.value.name}${local.defaults.intersight.policies.switch_control.name_suffix}"
  organization   = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  profiles = [
    for v in local.domains : v.moid if length(regexall(v.name, v.switch_control_policy)) > 0 || length(regexall(
      v.switch_control_policy, "${each.value.name}${local.defaults.intersight.policies.switch_control.name_suffix}")
    ) > 0
  ]
  tags = lookup(each.value, "tags", local.defaults.intersight.tags)
  udld_message_interval = lookup(
    each.value, "udld_message_interval", local.defaults.intersight.policies.switch_control.udld_message_interval
  )
  udld_recovery_action = lookup(
    each.value, "udld_recovery_action", local.defaults.intersight.policies.switch_control.udld_recovery_action
  )
  vlan_port_count_optimization = lookup(
    each.value, "vlan_port_count_optimization", local.defaults.intersight.policies.switch_control.vlan_port_count_optimization
  )
}


#_________________________________________________________________________
#
# Intersight Syslog Policy
# GUI Location: Configure > Policies > Create Policy > Syslog
#_________________________________________________________________________

module "syslog" {
  source  = "terraform-cisco-modules/policies-syslog/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "syslog", []) : v.name => v if lookup(
      local.modules.policies, "syslog", true
    )
  }
  description = lookup(each.value, "description", "")
  local_min_severity = lookup(
    each.value, "local_min_severity", local.defaults.intersight.policies.syslog.local_min_severity
  )
  name         = "${each.value.name}${local.defaults.intersight.policies.syslog.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  profiles = [
    for v in local.domains : {
      name        = v.moid
      object_type = "fabric.SwitchProfile"
      } if length(regexall(v.name, v.syslog_policy)) > 0 || length(regexall(
      v.syslog_policy, "${each.value.name}${local.defaults.intersight.policies.syslog.name_suffix}")
    ) > 0
  ]
  remote_clients = lookup(each.value, "remote_clients", [])
  tags           = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#_________________________________________________________________________
#
# Intersight System QoS Policy
# GUI Location: Configure > Policies > Create Policy > System QoS
#_________________________________________________________________________

module "system_qos" {
  source  = "terraform-cisco-modules/policies-system-qos/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "system_qos", []) : v.name => v if lookup(
      local.modules.policies, "system_qos", true
    )
  }
  description  = lookup(each.value, "description", "")
  classes      = lookup(each.value, "classes", [])
  name         = "${each.value.name}${local.defaults.intersight.policies.system_qos.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  profiles = [
    for v in local.domains : v.moid if length(regexall(v.name, v.system_qos_policy)) > 0 || length(regexall(
      v.system_qos_policy, "${each.value.name}${local.defaults.intersight.policies.system_qos.name_suffix}")
    ) > 0
  ]
  tags = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#_________________________________________________________________________
#
# Intersight Thermal Policy
# GUI Location: Configure > Policies > Create Policy > Thermal
#_________________________________________________________________________

module "thermal" {
  source  = "terraform-cisco-modules/policies-thermal/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "thermal", []) : v.name => v if lookup(
      local.modules.policies, "thermal", true
    )
  }
  description      = lookup(each.value, "description", "")
  fan_control_mode = lookup(each.value, "fan_control_mode", local.defaults.intersight.policies.thermal.fan_control_mode)
  name             = "${each.value.name}${local.defaults.intersight.policies.thermal.name_suffix}"
  organization     = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags             = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#_________________________________________________________________________
#
# Intersight Virtual KVM Policy
# GUI Location: Configure > Policies > Create Policy > Virtual KVM
#_________________________________________________________________________

module "virtual_kvm" {
  source  = "terraform-cisco-modules/policies-virtual-kvm/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "virtual_kvm", []) : v.name => v if lookup(
      local.modules.policies, "virtual_kvm", true
    )
  }
  allow_tunneled_vkvm = lookup(
    each.value, "allow_tunneled_vkvm", local.defaults.intersight.policies.virtual_kvm.allow_tunneled_vkvm
  )
  description = lookup(each.value, "description", "")
  enable_local_server_video = lookup(
    each.value, "enable_local_server_video", local.defaults.intersight.policies.virtual_kvm.enable_local_server_video
  )
  enable_video_encryption = lookup(
    each.value, "enable_video_encryption", local.defaults.intersight.policies.virtual_kvm.enable_video_encryption
  )
  enable_virtual_kvm = lookup(
    each.value, "enable_virtual_kvm", local.defaults.intersight.policies.virtual_kvm.enable_virtual_kvm
  )
  maximum_sessions = lookup(
    each.value, "maximum_sessions", local.defaults.intersight.policies.virtual_kvm.maximum_sessions
  )
  name         = "${each.value.name}${local.defaults.intersight.policies.virtual_kvm.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  remote_port  = lookup(each.value, "remote_port", local.defaults.intersight.policies.virtual_kvm.remote_port)
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#_________________________________________________________________________
#
# Intersight Virtual Media Policy
# GUI Location: Configure > Policies > Create Policy > Virtual Media
#_________________________________________________________________________

module "virtual_media" {
  source  = "terraform-cisco-modules/policies-virtual-media/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "virtual_media", []) : v.name => v if lookup(
      local.modules.policies, "virtual_media", true
    )
  }
  add_virtual_media = lookup(each.value, "add_virtual_media", [])
  description       = lookup(each.value, "description", "")
  enable_low_power_usb = lookup(
    each.value, "enable_low_power_usb", local.defaults.intersight.policies.virtual_media.enable_low_power_usb
  )
  enable_virtual_media = lookup(
    each.value, "enable_virtual_media", local.defaults.intersight.policies.virtual_media.enable_virtual_media
  )
  enable_virtual_media_encryption = lookup(
    each.value, "enable_virtual_media_encryption", local.defaults.intersight.policies.virtual_media.enable_virtual_media_encryption
  )
  name              = "${each.value.name}${local.defaults.intersight.policies.virtual_media.name_suffix}"
  organization      = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags              = lookup(each.value, "tags", local.defaults.intersight.tags)
  vmedia_password_1 = var.vmedia_password_1
  vmedia_password_2 = var.vmedia_password_2
  vmedia_password_3 = var.vmedia_password_3
  vmedia_password_4 = var.vmedia_password_4
  vmedia_password_5 = var.vmedia_password_5
}


#_________________________________________________________________________
#
# Intersight VLAN Policy
# GUI Location: Configure > Policies > Create Policy > VLAN
#_________________________________________________________________________

module "vlan" {
  depends_on = [
    module.multicast
  ]
  source  = "terraform-cisco-modules/policies-vlan/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "vlan", []) : v.name => v if lookup(
      local.modules.policies, "vlan", true
    )
  }
  description  = lookup(each.value, "description", "")
  name         = "${each.value.name}${local.defaults.intersight.policies.vlan.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  profiles = [
    for v in local.domains : v.moid if length(regexall(v.name, v.vlan_policy)) > 0 || length(regexall(
      v.vlan_policy, "${each.value.name}${local.defaults.intersight.policies.vlan.name_suffix}")
    ) > 0
  ]
  tags = lookup(each.value, "tags", local.defaults.intersight.tags)
  vlans = [
    for v in lookup(each.value, "vlans", []) : {
      auto_allow_on_uplinks = lookup(
        v, "auto_allow_on_uplinks", local.defaults.intersight.policies.vlan.vlans.auto_allow_on_uplinks
      )
      multicast_policy = module.multicast[v.multicast_policy].moid
      name             = lookup(v, "name", "")
      native_vlan      = lookup(v, "native_vlan", local.defaults.intersight.policies.vlan.vlans.native_vlan)
      vlan_list        = v.vlan_list
    }
  ]
}


#_________________________________________________________________________
#
# Intersight VSAN Policy
# GUI Location: Configure > Policies > Create Policy > VSAN
#_________________________________________________________________________

module "vsan" {
  source  = "terraform-cisco-modules/policies-vsan/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "vsan", []) : v.name => v if lookup(
      local.modules.policies, "vsan", true
    )
  }
  description  = lookup(each.value, "description", "")
  name         = "${each.value.name}${local.defaults.intersight.policies.vsan.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  profiles = [
    for v in local.domains : v.moid if length(regexall(v.name, v.vsan_policy)) > 0 || length(regexall(
      v.vsan_policy, "${each.value.name}${local.defaults.intersight.policies.vsan.name_suffix}")
    ) > 0
  ]
  tags            = lookup(each.value, "tags", local.defaults.intersight.tags)
  uplink_trunking = lookup(each.value, "uplink_trunking", local.defaults.intersight.policies.vsan.uplink_trunking)
  vsans           = lookup(each.value, "vsans", [])
}
