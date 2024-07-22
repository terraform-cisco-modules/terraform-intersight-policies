#__________________________________________________________
#
# Data Object Outputs
#__________________________________________________________

output "data_policies" {
  description = "Moid's of the Policies that were not defined locally."
  value = merge(
    { for e in sort(keys(local.policies_data)) : e => { for k, v in local.policies_data[e] : k => v.moid } }, {
      vhba_templates = { for k, v in local.data_vhba_template : k => v.moid }
      vnic_templates = { for k, v in local.data_vnic_template : k => v.moid }
  })
}
output "data_pools" {
  description = "Moid's of the Pools that were not defined locally."
  value       = { for e in sort(keys(local.pools_data)) : e => { for k, v in local.pools_data[e] : k => v.moid } }
}

#__________________________________________________________
#
# Policy Outputs
#__________________________________________________________
output "adapter_configuration" {
  description = "Moid's of the Adapter Configuration Policies."
  value       = { for k, v in intersight_adapter_config_policy.map : k => v.moid }
}
output "bios" {
  description = "Moid's of the BIOS Policies."
  value       = { for k, v in intersight_bios_policy.map : k => v.moid }
}
output "boot_order" {
  description = "Moid's of the Boot Order Policies."
  value       = { for k, v in intersight_boot_precision_policy.map : k => v.moid }
}
output "certificate_management" {
  description = "Moid's of the Certificate Management Policies."
  value       = { for k, v in intersight_certificatemanagement_policy.map : k => v.moid }
}
output "device_connector" {
  description = "Moid's of the Device Connector Policies."
  value       = { for k, v in intersight_deviceconnector_policy.map : k => v.moid }
}
output "drive_security" {
  description = "Moid's of the Drive Security Policies."
  value       = { for k, v in intersight_storage_drive_security_policy.map : k => v.moid }
}
output "ethernet_adapter" {
  description = "Moid's of the Ethernet Adapter Policies."
  value       = { for k, v in intersight_vnic_eth_adapter_policy.map : k => v.moid }
}
output "ethernet_network" {
  description = "Moid's of the Ethernet Network Policies."
  value       = { for k, v in intersight_vnic_eth_network_policy.map : k => v.moid }
}
output "ethernet_network_control" {
  description = "Moid's of the Ethernet Network Control Policies."
  value       = { for k, v in intersight_fabric_eth_network_control_policy.map : k => v.moid }
}
output "ethernet_network_group" {
  description = "Moid's of the Ethernet Network Group Policies."
  value       = { for k, v in intersight_fabric_eth_network_group_policy.map : k => v.moid }
}
output "ethernet_qos" {
  description = "Moid's of the Ethernet QoS Policies."
  value       = { for k, v in intersight_vnic_eth_qos_policy.map : k => v.moid }
}
output "fc_zone" {
  description = "Moid's of the FC Zone Policies."
  value       = { for k, v in intersight_fabric_fc_zone_policy.map : k => v.moid }
}
output "fibre_channel_adapter" {
  description = "Moid's of the Fibre Channel Adapter Policies."
  value       = { for k, v in intersight_vnic_fc_adapter_policy.map : k => v.moid }
}
output "fibre_channel_network" {
  description = "Moid's of the Fibre Channel Network Policies."
  value       = { for k, v in intersight_vnic_fc_network_policy.map : k => v.moid }
}
output "fibre_channel_qos" {
  description = "Moid's of the Fibre Channel QoS Policies."
  value       = { for k, v in intersight_vnic_eth_qos_policy.map : k => v.moid }
}
output "flow_control" {
  description = "Moid's of the Flow Control Policies."
  value       = { for k, v in intersight_fabric_flow_control_policy.map : k => v.moid }
}
output "firmware" {
  description = "Moid's of the Firmware Policies."
  value       = { for k, v in intersight_firmware_policy.map : k => v.moid }
}
output "imc_access" {
  description = "Moid's of the IMC Access Policies."
  value       = { for k, v in intersight_access_policy.map : k => v.moid }
}
output "ipmi_over_lan" {
  description = "Moid's of the IPMI over LAN Policies."
  value       = { for k, v in intersight_ipmioverlan_policy.map : k => v.moid }
}
output "iscsi_adapter" {
  description = "Moid's of the iSCSI Adapter Policies."
  value       = { for k, v in intersight_vnic_iscsi_adapter_policy.map : k => v.moid }
}
output "iscsi_boot" {
  description = "Moid's of the iSCSI Boot Policies."
  value       = { for k, v in intersight_vnic_iscsi_boot_policy.map : k => v.moid }
}
output "iscsi_static_target" {
  description = "Moid's of the iSCSI Static Target Policies."
  value       = { for k, v in intersight_vnic_iscsi_static_target_policy.map : k => v.moid }
}
output "lan_connectivity" {
  description = "Moid's of the LAN Connectivity Policies."
  value       = { for k, v in intersight_vnic_lan_connectivity_policy.map : k => v.moid }
}
output "lan_connectivity_vnics" {
  description = "Moid's of the LAN Connectivity - VNICs Policies."
  value = merge(
    { for k, v in intersight_vnic_eth_if.map : k => v.moid },
    { for k, v in intersight_vnic_eth_if.from_template : k => v.moid }
  )
}
output "link_aggregation" {
  description = "Moid's of the Link Control Policies."
  value       = { for k, v in intersight_fabric_link_aggregation_policy.map : k => v.moid }
}
output "link_control" {
  description = "Moid's of the Link Control Policies."
  value       = { for k, v in intersight_fabric_link_control_policy.map : k => v.moid }
}
output "ldap" {
  description = "Moid's of the LDAP Policies."
  value       = { for k, v in intersight_iam_ldap_policy.map : k => v.moid }
}
output "local_user" {
  description = "Moid's of the Local User Policies."
  value       = { for k, v in intersight_iam_end_point_user_policy.map : k => v.moid }
}
output "multicast" {
  description = "Moid's of the Multicast Policies."
  value       = { for k, v in intersight_fabric_multicast_policy.map : k => v.moid }
}
output "network_connectivity" {
  description = "Moid's of the Network Connectivity Policies."
  value       = { for k, v in intersight_networkconfig_policy.map : k => v.moid }
}
output "ntp" {
  description = "Moid's of the NTP Policies."
  value       = { for k, v in intersight_ntp_policy.map : k => v.moid }
}
output "persistent_memory" {
  description = "Moid's of the Persistent Memory Policies."
  value       = { for k, v in intersight_memory_persistent_memory_policy.map : k => v.moid }
}
output "port" {
  description = "Moid's of the Port Policies."
  value       = { for k, v in intersight_fabric_port_policy.map : k => v.moid }
}
output "ports" {
  description = "Moid's of the Port Child Policies."
  value = {
    lan_pin_groups                = { for k, v in intersight_fabric_lan_pin_group.map : k => v.moid }
    port_channel_appliances       = { for k, v in intersight_fabric_appliance_pc_role.map : k => v.moid }
    port_channel_appliances       = { for k, v in intersight_fabric_appliance_pc_role.map : k => v.moid }
    port_channel_ethernet_uplinks = { for k, v in intersight_fabric_uplink_pc_role.map : k => v.moid }
    port_channel_fc_uplinks       = { for k, v in intersight_fabric_fc_uplink_pc_role.map : k => v.moid }
    port_channel_fcoe_uplinks     = { for k, v in intersight_fabric_fcoe_uplink_pc_role.map : k => v.moid }
    port_modes                    = { for k, v in intersight_fabric_port_mode.map : k => v.moid }
    port_role_appliances          = { for k, v in intersight_fabric_appliance_role.map : k => v.moid }
    port_role_ethernet_uplinks    = { for k, v in intersight_fabric_uplink_role.map : k => v.moid }
    port_role_fc_storage          = { for k, v in intersight_fabric_fc_storage_role.map : k => v.moid }
    port_role_fc_uplinks          = { for k, v in intersight_fabric_fc_uplink_role.map : k => v.moid }
    port_role_fcoe_uplinks        = { for k, v in intersight_fabric_fcoe_uplink_role.map : k => v.moid }
    port_role_servers             = { for k, v in intersight_fabric_server_role.map : k => v.moid }
    san_pin_groups                = { for k, v in intersight_fabric_san_pin_group.map : k => v.moid }
  }
}
output "power" {
  description = "Moid's of the Power Policies."
  value       = { for k, v in intersight_power_policy.map : k => v.moid }
}
output "san_connectivity" {
  description = "Moid's of the SAN Connectivity Policies."
  value       = { for k, v in intersight_vnic_san_connectivity_policy.map : k => v.moid }
}
output "san_connectivity_vhbas" {
  description = "Moid's of the SAN Connectivity - VHBAs Policies."
  value = merge(
    { for k, v in intersight_vnic_fc_if.map : k => v.moid },
    { for k, v in intersight_vnic_fc_if.from_template : k => v.moid }
  )
}
output "sd_card" {
  description = "Moid's of the SD Card Policies."
  value       = { for k, v in intersight_sdcard_policy.map : k => v.moid }
}
output "serial_over_lan" {
  description = "Moid's of the Serial over LAN Policies."
  value       = { for k, v in intersight_sol_policy.map : k => v.moid }
}
output "smtp" {
  description = "Moid's of the SMTP Policies."
  value       = { for k, v in intersight_smtp_policy.map : k => v.moid }
}
output "snmp" {
  description = "Moid's of the SNMP Policies."
  value       = { for k, v in intersight_snmp_policy.map : k => v.moid }
}
output "ssh" {
  description = "Moid's of the SSH Policies."
  value       = { for k, v in intersight_ssh_policy.map : k => v.moid }
}
output "storage" {
  description = "Moid's of the Storage Policies."
  value       = { for k, v in intersight_storage_storage_policy.map : k => v.moid }
}
output "switch_control" {
  description = "Moid's of the Switch Control Policies."
  value       = { for k, v in intersight_fabric_switch_control_policy.map : k => v.moid }
}
output "syslog" {
  description = "Moid's of the Syslog Policies."
  value       = { for k, v in intersight_syslog_policy.map : k => v.moid }
}
output "system_qos" {
  description = "Moid's of the System QoS Policies."
  value       = { for k, v in intersight_fabric_system_qos_policy.map : k => v.moid }
}
output "thermal" {
  description = "Moid's of the Thermal Policies."
  value       = { for k, v in intersight_thermal_policy.map : k => v.moid }
}
output "vhba_template" {
  description = "Moid's of the vHBA Templates."
  value       = { for k, v in intersight_vnic_vhba_template.map : k => v.moid }
}
output "virtual_kvm" {
  description = "Moid's of the Virtual KVM Policies."
  value       = { for k, v in intersight_kvm_policy.map : k => v.moid }
}
output "virtual_media" {
  description = "Moid's of the Virtual Media Policies."
  value       = { for k, v in intersight_vmedia_policy.map : k => v.moid }
}
output "vlan" {
  description = "Moid's of the VLAN Policies."
  value       = { for k, v in intersight_fabric_eth_network_policy.map : k => v.moid }
}
output "vnic_template" {
  description = "Moid's of the vNIC Templates."
  value       = { for k, v in intersight_vnic_vnic_template.map : k => v.moid }
}
output "vsan" {
  description = "Moid's of the VSAN Policies."
  value       = { for k, v in intersight_fabric_fc_network_policy.map : k => v.moid }
}
