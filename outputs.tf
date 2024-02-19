#__________________________________________________________
#
# Data Object Outputs
#__________________________________________________________

output "data_policies" {
  value = { for e in keys(data.intersight_search_search_item.policies) : e => {
    for i in data.intersight_search_search_item.policies[e
    ].results : "${local.org_moids[jsondecode(i.additional_properties).Organization.Moid]}/${jsondecode(i.additional_properties).Name}" => i.moid }
  }
}
output "data_pools" {
  value = { for e in keys(data.intersight_search_search_item.pools) : e => {
    for i in data.intersight_search_search_item.pools[e
    ].results : "${local.org_moids[jsondecode(i.additional_properties).Organization.Moid]}/${jsondecode(i.additional_properties).Name}" => i.moid }
  }
}

#__________________________________________________________
#
# Policy Outputs
#__________________________________________________________

output "adapter_configuration" {
  description = "Moid's of the Adapter Configuration Policies."
  value       = { for v in sort(keys(intersight_adapter_config_policy.map)) : v => intersight_adapter_config_policy.map[v].moid }
}

output "bios" {
  description = "Moid's of the BIOS Policies."
  value       = { for v in sort(keys(intersight_bios_policy.map)) : v => intersight_bios_policy.map[v].moid }
}

output "boot_order" {
  description = "Moid's of the Boot Order Policies."
  value       = { for v in sort(keys(intersight_boot_precision_policy.map)) : v => intersight_boot_precision_policy.map[v].moid }
}

output "certificate_management" {
  description = "Moid's of the Certificate Management Policies."
  value       = { for v in sort(keys(intersight_certificatemanagement_policy.map)) : v => intersight_certificatemanagement_policy.map[v].moid }
}

output "device_connector" {
  description = "Moid's of the Device Connector Policies."
  value       = { for v in sort(keys(intersight_deviceconnector_policy.map)) : v => intersight_deviceconnector_policy.map[v].moid }
}

output "drive_security" {
  description = "Moid's of the Drive Security Policies."
  value       = { for v in sort(keys(intersight_storage_drive_security_policy.map)) : v => intersight_storage_drive_security_policy.map[v].moid }
}

output "ethernet_adapter" {
  description = "Moid's of the Ethernet Adapter Policies."
  value       = { for v in sort(keys(intersight_vnic_eth_adapter_policy.map)) : v => intersight_vnic_eth_adapter_policy.map[v].moid }
}

output "ethernet_network" {
  description = "Moid's of the Ethernet Network Policies."
  value       = { for v in sort(keys(intersight_vnic_eth_network_policy.map)) : v => intersight_vnic_eth_network_policy.map[v].moid }
}

output "ethernet_network_control" {
  description = "Moid's of the Ethernet Network Control Policies."
  value = {
    for v in sort(keys(intersight_fabric_eth_network_control_policy.map)) : v => intersight_fabric_eth_network_control_policy.map[v].moid
  }
}

output "ethernet_network_group" {
  description = "Moid's of the Ethernet Network Group Policies."
  value = {
    for v in sort(keys(intersight_fabric_eth_network_group_policy.map)) : v => intersight_fabric_eth_network_group_policy.map[v].moid
  }
}

output "ethernet_qos" {
  description = "Moid's of the Ethernet QoS Policies."
  value       = { for v in sort(keys(intersight_vnic_eth_qos_policy.map)) : v => intersight_vnic_eth_qos_policy.map[v].moid }
}

output "fc_zone" {
  description = "Moid's of the FC Zone Policies."
  value       = { for v in sort(keys(intersight_fabric_fc_zone_policy.map)) : v => intersight_fabric_fc_zone_policy.map[v].moid }
}

output "fibre_channel_adapter" {
  description = "Moid's of the Fibre Channel Adapter Policies."
  value       = { for v in sort(keys(intersight_vnic_fc_adapter_policy.map)) : v => intersight_vnic_fc_adapter_policy.map[v].moid }
}

output "fibre_channel_network" {
  description = "Moid's of the Fibre Channel Network Policies."
  value       = { for v in sort(keys(intersight_vnic_fc_network_policy.map)) : v => intersight_vnic_fc_network_policy.map[v].moid }
}

output "fibre_channel_qos" {
  description = "Moid's of the Fibre Channel QoS Policies."
  value       = { for v in sort(keys(intersight_vnic_eth_qos_policy.map)) : v => intersight_vnic_eth_qos_policy.map[v].moid }
}

output "flow_control" {
  description = "Moid's of the Flow Control Policies."
  value       = { for v in sort(keys(intersight_fabric_flow_control_policy.map)) : v => intersight_fabric_flow_control_policy.map[v].moid }
}

output "firmware" {
  description = "Moid's of the Firmware Policies."
  value       = { for v in sort(keys(intersight_firmware_policy.map)) : v => intersight_firmware_policy.map[v].moid }
}

output "imc_access" {
  description = "Moid's of the IMC Access Policies."
  value       = { for v in sort(keys(intersight_access_policy.map)) : v => intersight_access_policy.map[v].moid }
}

output "ipmi_over_lan" {
  description = "Moid's of the IPMI over LAN Policies."
  value       = { for v in sort(keys(intersight_ipmioverlan_policy.map)) : v => intersight_ipmioverlan_policy.map[v].moid }
}

output "iscsi_adapter" {
  description = "Moid's of the iSCSI Adapter Policies."
  value       = { for v in sort(keys(intersight_vnic_iscsi_adapter_policy.map)) : v => intersight_vnic_iscsi_adapter_policy.map[v].moid }
}

output "iscsi_boot" {
  description = "Moid's of the iSCSI Boot Policies."
  value       = { for v in sort(keys(intersight_vnic_iscsi_boot_policy.map)) : v => intersight_vnic_iscsi_boot_policy.map[v].moid }
}

output "iscsi_static_target" {
  description = "Moid's of the iSCSI Static Target Policies."
  value       = { for v in sort(keys(intersight_vnic_iscsi_static_target_policy.map)) : v => intersight_vnic_iscsi_static_target_policy.map[v].moid }
}

output "lan_connectivity" {
  description = "Moid's of the LAN Connectivity Policies."
  value       = { for v in sort(keys(intersight_vnic_lan_connectivity_policy.map)) : v => intersight_vnic_lan_connectivity_policy.map[v].moid }
}

output "lan_connectivity_vnics" {
  description = "Moid's of the LAN Connectivity - VNICs Policies."
  value       = { for v in sort(keys(intersight_vnic_eth_if.map)) : v => intersight_vnic_eth_if.map[v].moid }
}

output "link_aggregation" {
  description = "Moid's of the Link Control Policies."
  value       = { for v in sort(keys(intersight_fabric_link_aggregation_policy.map)) : v => intersight_fabric_link_aggregation_policy.map[v].moid }
}

output "link_control" {
  description = "Moid's of the Link Control Policies."
  value       = { for v in sort(keys(intersight_fabric_link_control_policy.map)) : v => intersight_fabric_link_control_policy.map[v].moid }
}

output "ldap" {
  description = "Moid's of the LDAP Policies."
  value       = { for v in sort(keys(intersight_iam_ldap_policy.map)) : v => intersight_iam_ldap_policy.map[v].moid }
}

output "local_user" {
  description = "Moid's of the Local User Policies."
  value       = { for v in sort(keys(intersight_iam_end_point_user_policy.map)) : v => intersight_iam_end_point_user_policy.map[v].moid }
}

output "multicast" {
  description = "Moid's of the Multicast Policies."
  value       = { for v in sort(keys(intersight_fabric_multicast_policy.map)) : v => intersight_fabric_multicast_policy.map[v].moid }
}

output "network_connectivity" {
  description = "Moid's of the Network Connectivity Policies."
  value       = { for v in sort(keys(intersight_networkconfig_policy.map)) : v => intersight_networkconfig_policy.map[v].moid }
}

output "ntp" {
  description = "Moid's of the NTP Policies."
  value       = { for v in sort(keys(intersight_ntp_policy.map)) : v => intersight_ntp_policy.map[v].moid }
}

output "persistent_memory" {
  description = "Moid's of the Persistent Memory Policies."
  value       = { for v in sort(keys(intersight_memory_persistent_memory_policy.map)) : v => intersight_memory_persistent_memory_policy.map[v].moid }
}

output "port" {
  description = "Moid's of the Port Policies."
  value       = { for v in sort(keys(intersight_fabric_port_policy.map)) : v => intersight_fabric_port_policy.map[v].moid }
}

output "power" {
  description = "Moid's of the Power Policies."
  value       = { for v in sort(keys(intersight_power_policy.map)) : v => intersight_power_policy.map[v].moid }
}

output "san_connectivity" {
  description = "Moid's of the SAN Connectivity Policies."
  value       = { for v in sort(keys(intersight_vnic_san_connectivity_policy.map)) : v => intersight_vnic_san_connectivity_policy.map[v].moid }
}

output "san_connectivity_vhbas" {
  description = "Moid's of the SAN Connectivity - VHBAs Policies."
  value       = { for v in sort(keys(intersight_vnic_fc_if.map)) : v => intersight_vnic_fc_if.map[v].moid }
}

output "sd_card" {
  description = "Moid's of the SD Card Policies."
  value       = { for v in sort(keys(intersight_sdcard_policy.map)) : v => intersight_sdcard_policy.map[v].moid }
}

output "serial_over_lan" {
  description = "Moid's of the Serial over LAN Policies."
  value       = { for v in sort(keys(intersight_sol_policy.map)) : v => intersight_sol_policy.map[v].moid }
}

output "smtp" {
  description = "Moid's of the SMTP Policies."
  value       = { for v in sort(keys(intersight_smtp_policy.map)) : v => intersight_smtp_policy.map[v].moid }
}

output "snmp" {
  description = "Moid's of the SNMP Policies."
  value       = { for v in sort(keys(intersight_snmp_policy.map)) : v => intersight_snmp_policy.map[v].moid }
}

output "ssh" {
  description = "Moid's of the SSH Policies."
  value       = { for v in sort(keys(intersight_ssh_policy.map)) : v => intersight_ssh_policy.map[v].moid }
}

output "storage" {
  description = "Moid's of the Storage Policies."
  value       = { for v in sort(keys(intersight_storage_storage_policy.map)) : v => intersight_storage_storage_policy.map[v].moid }
}

output "switch_control" {
  description = "Moid's of the Switch Control Policies."
  value       = { for v in sort(keys(intersight_fabric_switch_control_policy.map)) : v => intersight_fabric_switch_control_policy.map[v].moid }
}

output "syslog" {
  description = "Moid's of the Syslog Policies."
  value       = { for v in sort(keys(intersight_syslog_policy.map)) : v => intersight_syslog_policy.map[v].moid }
}

output "system_qos" {
  description = "Moid's of the System QoS Policies."
  value       = { for v in sort(keys(intersight_fabric_system_qos_policy.map)) : v => intersight_fabric_system_qos_policy.map[v].moid }
}

output "thermal" {
  description = "Moid's of the Thermal Policies."
  value       = { for v in sort(keys(intersight_thermal_policy.map)) : v => intersight_thermal_policy.map[v].moid }
}

output "virtual_kvm" {
  description = "Moid's of the Virtual KVM Policies."
  value       = { for v in sort(keys(intersight_kvm_policy.map)) : v => intersight_kvm_policy.map[v].moid }
}

output "virtual_media" {
  description = "Moid's of the Virtual Media Policies."
  value       = { for v in sort(keys(intersight_vmedia_policy.map)) : v => intersight_vmedia_policy.map[v].moid }
}

output "vlan" {
  description = "Moid's of the VLAN Policies."
  value       = { for v in sort(keys(intersight_fabric_eth_network_policy.map)) : v => intersight_fabric_eth_network_policy.map[v].moid }
}

output "vsan" {
  description = "Moid's of the VSAN Policies."
  value       = { for v in sort(keys(intersight_fabric_fc_network_policy.map)) : v => intersight_fabric_fc_network_policy.map[v].moid }
}
