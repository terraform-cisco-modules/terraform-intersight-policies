#__________________________________________________________
#
# Adapter Configuration Policy Outputs
#__________________________________________________________

output "adapter_configuration" {
  description = "Moid's of the Adapter Configuration Policies."
  value       = { for v in sort(keys(intersight_adapter_config_policy.map)) : v => intersight_adapter_config_policy.map[v].moid }
}


#__________________________________________________________
#
# BIOS Policy Outputs
#__________________________________________________________

output "bios" {
  description = "Moid's of the BIOS Policies."
  value       = { for v in sort(keys(intersight_bios_policy.map)) : v => intersight_bios_policy.map[v].moid }
}


#__________________________________________________________
#
# Boot Order Policy Outputs
#__________________________________________________________

output "boot_order" {
  description = "Moid's of the Boot Order Policies."
  value = { for v in sort(keys(intersight_boot_precision_policy.map)
  ) : v => intersight_boot_precision_policy.map[v].moid }
}


#__________________________________________________________
#
# Certificate Management Policy Outputs
#__________________________________________________________

output "certificate_management" {
  description = "Moid's of the Certificate Management Policies."
  value = { for v in sort(keys(intersight_certificatemanagement_policy.map)
  ) : v => intersight_certificatemanagement_policy.map[v].moid }
}


#__________________________________________________________
#
# Device Connector Policy Outputs
#__________________________________________________________

output "device_connector" {
  description = "Moid's of the Device Connector Policies."
  value       = { for v in sort(keys(intersight_deviceconnector_policy.map)) : v => intersight_deviceconnector_policy.map[v].moid }
}


#__________________________________________________________
#
# Firmware Policy Outputs
#__________________________________________________________

output "firmware" {
  description = "Moid's of the Firmware Policies."
  value       = { for v in sort(keys(intersight_firmware_policy.map)) : v => intersight_firmware_policy.map[v].moid }
}


#__________________________________________________________
#
# IMC Access Policy Outputs
#__________________________________________________________

output "imc_access" {
  description = "Moid's of the IMC Access Policies."
  value       = { for v in sort(keys(intersight_access_policy.map)) : v => intersight_access_policy.map[v].moid }
}


#__________________________________________________________
#
# IPMI over LAN Policy Outputs
#__________________________________________________________

output "ipmi_over_lan" {
  description = "Moid's of the IPMI over LAN Policies."
  value       = { for v in sort(keys(intersight_ipmioverlan_policy.map)) : v => intersight_ipmioverlan_policy.map[v].moid }
}


#__________________________________________________________
#
# LAN Connectivity Policy Outputs
#__________________________________________________________

output "lan_connectivity" {
  description = "Moid's of the LAN Connectivity Policies."
  value = { for v in sort(keys(intersight_vnic_lan_connectivity_policy.map)
  ) : v => intersight_vnic_lan_connectivity_policy.map[v].moid }
}

#__________________________________________________________
#
# LDAP Policy Outputs
#__________________________________________________________

output "ldap" {
  description = "Moid's of the LDAP Policies."
  value       = { for v in sort(keys(intersight_iam_ldap_policy.map)) : v => intersight_iam_ldap_policy.map[v].moid }
}


#__________________________________________________________
#
# Local User Policy Outputs
#__________________________________________________________

output "local_user" {
  description = "Moid's of the Local User Policies."
  value = { for v in sort(keys(intersight_iam_end_point_user_policy.map)
  ) : v => intersight_iam_end_point_user_policy.map[v].moid }
}


#__________________________________________________________
#
# Network Connectivity Policy Outputs
#__________________________________________________________

output "network_connectivity" {
  description = "Moid's of the Network Connectivity Policies."
  value       = { for v in sort(keys(intersight_networkconfig_policy.map)) : v => intersight_networkconfig_policy.map[v].moid }
}


#__________________________________________________________
#
# NTP Policy Outputs
#__________________________________________________________

output "ntp" {
  description = "Moid's of the NTP Policies."
  value       = { for v in sort(keys(intersight_ntp_policy.map)) : v => intersight_ntp_policy.map[v].moid }
}


#__________________________________________________________
#
# Persistent Memory Policy Outputs
#__________________________________________________________

output "persistent_memory" {
  description = "Moid's of the Persistent Memory Policies."
  value = { for v in sort(keys(intersight_memory_persistent_memory_policy.map)
  ) : v => intersight_memory_persistent_memory_policy.map[v].moid }
}


#__________________________________________________________
#
# Port Policy Outputs
#__________________________________________________________

output "port" {
  description = "Moid's of the Port Policies."
  value       = { for v in sort(keys(intersight_fabric_port_policy.map)) : v => intersight_fabric_port_policy.map[v].moid }
}


#__________________________________________________________
#
# Power Policy Outputs
#__________________________________________________________

output "power" {
  description = "Moid's of the Power Policies."
  value       = { for v in sort(keys(intersight_power_policy.map)) : v => intersight_power_policy.map[v].moid }
}


#__________________________________________________________
#
# SAN Connectivity Policy Outputs
#__________________________________________________________

output "san_connectivity" {
  description = "Moid's of the SAN Connectivity Policies."
  value = { for v in sort(keys(intersight_vnic_san_connectivity_policy.map)
  ) : v => intersight_vnic_san_connectivity_policy.map[v].moid }
}


#__________________________________________________________
#
# Serial over LAN Policy Outputs
#__________________________________________________________

output "serial_over_lan" {
  description = "Moid's of the Serial over LAN Policies."
  value       = { for v in sort(keys(intersight_sol_policy.map)) : v => intersight_sol_policy.map[v].moid }
}


#__________________________________________________________
#
# SMTP Policy Outputs
#__________________________________________________________

output "smtp" {
  description = "Moid's of the SMTP Policies."
  value       = { for v in sort(keys(intersight_smtp_policy.map)) : v => intersight_smtp_policy.map[v].moid }
}


#__________________________________________________________
#
# SNMP Policy Outputs
#__________________________________________________________

output "snmp" {
  description = "Moid's of the SNMP Policies."
  value       = { for v in sort(keys(intersight_snmp_policy.map)) : v => intersight_snmp_policy.map[v].moid }
}


#__________________________________________________________
#
# SSH Policy Outputs
#__________________________________________________________

output "ssh" {
  description = "Moid's of the SSH Policies."
  value       = { for v in sort(keys(intersight_ssh_policy.map)) : v => intersight_ssh_policy.map[v].moid }
}


#__________________________________________________________
#
# Storage Policy Outputs
#__________________________________________________________

output "storage" {
  description = "Moid's of the Storage Policies."
  value       = { for v in sort(keys(intersight_storage_storage_policy.map)) : v => intersight_storage_storage_policy.map[v].moid }
}


#__________________________________________________________
#
# Switch Control Policy Outputs
#__________________________________________________________

output "switch_control" {
  description = "Moid's of the Switch Control Policies."
  value = { for v in sort(keys(intersight_fabric_switch_control_policy.map)
  ) : v => intersight_fabric_switch_control_policy.map[v].moid }
}


#__________________________________________________________
#
# Syslog Policy Outputs
#__________________________________________________________

output "syslog" {
  description = "Moid's of the Syslog Policies."
  value       = { for v in sort(keys(intersight_syslog_policy.map)) : v => intersight_syslog_policy.map[v].moid }
}


#__________________________________________________________
#
# System QoS Policy Outputs
#__________________________________________________________

output "system_qos" {
  description = "Moid's of the System QoS Policies."
  value = { for v in sort(keys(intersight_fabric_system_qos_policy.map)
  ) : v => intersight_fabric_system_qos_policy.map[v].moid }
}


#__________________________________________________________
#
# Thermal Policy Outputs
#__________________________________________________________

output "thermal" {
  description = "Moid's of the Thermal Policies."
  value       = { for v in sort(keys(intersight_thermal_policy.map)) : v => intersight_thermal_policy.map[v].moid }
}


#__________________________________________________________
#
# Virtual KVM Policy Outputs
#__________________________________________________________

output "virtual_kvm" {
  description = "Moid's of the Virtual KVM Policies."
  value       = { for v in sort(keys(intersight_kvm_policy.map)) : v => intersight_kvm_policy.map[v].moid }
}


#__________________________________________________________
#
# Virtual Media Policy Outputs
#__________________________________________________________

output "virtual_media" {
  description = "Moid's of the Virtual Media Policies."
  value       = { for v in sort(keys(intersight_vmedia_policy.map)) : v => intersight_vmedia_policy.map[v].moid }
}


#__________________________________________________________
#
# VLAN Policy Outputs
#__________________________________________________________

output "vlan" {
  description = "Moid's of the VLAN Policies."
  value = { for v in sort(keys(intersight_fabric_eth_network_policy.map)
  ) : v => intersight_fabric_eth_network_policy.map[v].moid }
}


#__________________________________________________________
#
# VSAN Policy Outputs
#__________________________________________________________

output "vsan" {
  description = "Moid's of the VSAN Policies."
  value       = { for v in sort(keys(intersight_fabric_fc_network_policy.map)) : v => intersight_fabric_fc_network_policy.map[v].moid }
}
