#__________________________________________________________
#
# Adapter Configuration Policy Outputs
#__________________________________________________________

output "adapter_configuration" {
  description = "Moid's of the Adapter Configuration Policies."
  value = length(local.adapter_configuration) > 0 ? { for v in sort(
    keys(intersight_adapter_config_policy.adapter_configuration)
  ) : v => intersight_adapter_config_policy.adapter_configuration[v].moid } : {}
}


#__________________________________________________________
#
# BIOS Policy Outputs
#__________________________________________________________

output "bios" {
  description = "Moid's of the BIOS Policies."
  value = length(local.bios) > 0 ? { for v in sort(
    keys(intersight_bios_policy.bios)
  ) : v => intersight_bios_policy.bios[v].moid } : {}
}


#__________________________________________________________
#
# Boot Order Policy Outputs
#__________________________________________________________

output "boot_order" {
  description = "Moid's of the Boot Order Policies."
  value = length(local.boot_order) > 0 ? { for v in sort(
    keys(intersight_boot_precision_policy.boot_order)
  ) : v => intersight_boot_precision_policy.boot_order[v].moid } : {}
}


#__________________________________________________________
#
# Certificate Management Policy Outputs
#__________________________________________________________

output "certificate_management" {
  description = "Moid's of the Certificate Management Policies."
  value = length(lookup(local.policies, "certificate_management", [])) > 0 ? { for v in sort(
    keys(intersight_certificatemanagement_policy.certificate_management)
  ) : v => intersight_certificatemanagement_policy.certificate_management[v].moid } : {}
}


#__________________________________________________________
#
# Device Connector Policy Outputs
#__________________________________________________________

output "device_connector" {
  description = "Moid's of the Device Connector Policies."
  value = length(lookup(local.policies, "device_connector", [])) > 0 ? { for v in sort(
    keys(intersight_deviceconnector_policy.device_connector)
  ) : v => intersight_deviceconnector_policy.device_connector[v].moid } : {}
}


#__________________________________________________________
#
# IMC Access Policy Outputs
#__________________________________________________________

output "imc_access" {
  description = "Moid's of the IMC Access Policies."
  value = length(lookup(local.policies, "imc_access", [])) > 0 ? { for v in sort(
    keys(intersight_access_policy.imc_access)
  ) : v => intersight_access_policy.imc_access[v].moid } : {}
}


#__________________________________________________________
#
# IPMI over LAN Policy Outputs
#__________________________________________________________

output "ipmi_over_lan" {
  description = "Moid's of the IPMI over LAN Policies."
  value = length(lookup(local.policies, "ipmi_over_lan", [])) > 0 ? { for v in sort(
    keys(intersight_ipmioverlan_policy.ipmi_over_lan)
  ) : v => intersight_ipmioverlan_policy.ipmi_over_lan[v].moid } : {}
}


#__________________________________________________________
#
# LAN Connectivity Policy Outputs
#__________________________________________________________

output "lan_connectivity" {
  description = "Moid's of the LAN Connectivity Policies."
  value = length(local.lan_connectivity) > 0 ? { for v in sort(
    keys(intersight_vnic_lan_connectivity_policy.lan_connectivity)
  ) : v => intersight_vnic_lan_connectivity_policy.lan_connectivity[v].moid } : {}
}

#__________________________________________________________
#
# LDAP Policy Outputs
#__________________________________________________________

output "ldap" {
  description = "Moid's of the LDAP Policies."
  value = length(local.ldap) > 0 ? { for v in sort(
    keys(intersight_iam_ldap_policy.ldap)
  ) : v => intersight_iam_ldap_policy.ldap[v].moid } : {}
}


#__________________________________________________________
#
# Local User Policy Outputs
#__________________________________________________________

output "local_user" {
  description = "Moid's of the Local User Policies."
  value = length(local.local_user) > 0 ? { for v in sort(
    keys(intersight_iam_end_point_user_policy.local_user)
  ) : v => intersight_iam_end_point_user_policy.local_user[v].moid } : {}
}


#__________________________________________________________
#
# Network Connectivity Policy Outputs
#__________________________________________________________

output "network_connectivity" {
  description = "Moid's of the Network Connectivity Policies."
  value = length(local.network_connectivity) > 0 ? { for v in sort(
    keys(intersight_networkconfig_policy.network_connectivity)
  ) : v => intersight_networkconfig_policy.network_connectivity[v].moid } : {}
}


#__________________________________________________________
#
# NTP Policy Outputs
#__________________________________________________________

output "ntp" {
  description = "Moid's of the NTP Policies."
  value = length(local.ntp) > 0 ? { for v in sort(
    keys(intersight_ntp_policy.ntp)
  ) : v => intersight_ntp_policy.ntp[v].moid } : {}
}


#__________________________________________________________
#
# Persistent Memory Policy Outputs
#__________________________________________________________

#output "persistent_memory" {
#  description = "Moid's of the Persistent Memory Policies."
#  value = length(local.persistent_memory) > 0 ? { for v in sort(
#    keys(module.persistent_memory)
#  ) : v => module.persistent_memory[v].moid } : {}
#}


#__________________________________________________________
#
# Port Policy Outputs
#__________________________________________________________

output "port" {
  description = "Moid's of the Port Policies."
  value = length(local.port) > 0 ? { for v in sort(
    keys(intersight_fabric_port_policy.port)
  ) : v => intersight_fabric_port_policy.port[v].moid } : {}
}


#__________________________________________________________
#
# Power Policy Outputs
#__________________________________________________________

output "power" {
  description = "Moid's of the Power Policies."
  value = length(lookup(local.policies, "power", [])) > 0 ? { for v in sort(
    keys(intersight_power_policy.power)
  ) : v => intersight_power_policy.power[v].moid } : {}
}


#__________________________________________________________
#
# SAN Connectivity Policy Outputs
#__________________________________________________________

output "san_connectivity" {
  description = "Moid's of the SAN Connectivity Policies."
  value = length(local.san_connectivity) > 0 ? { for v in sort(
    keys(intersight_vnic_san_connectivity_policy.san_connectivity)
  ) : v => intersight_vnic_san_connectivity_policy.san_connectivity[v].moid } : {}
}


#__________________________________________________________
#
# Serial over LAN Policy Outputs
#__________________________________________________________

output "serial_over_lan" {
  description = "Moid's of the Serial over LAN Policies."
  value = length(lookup(local.policies, "serial_over_lan", [])) > 0 ? { for v in sort(
    keys(intersight_sol_policy.serial_over_lan)
  ) : v => intersight_sol_policy.serial_over_lan[v].moid } : {}
}


#__________________________________________________________
#
# SMTP Policy Outputs
#__________________________________________________________

output "smtp" {
  description = "Moid's of the SMTP Policies."
  value = length(lookup(local.policies, "smtp", [])) > 0 ? { for v in sort(
    keys(intersight_smtp_policy.smtp)
  ) : v => intersight_smtp_policy.smtp[v].moid } : {}
}


#__________________________________________________________
#
# SNMP Policy Outputs
#__________________________________________________________

output "snmp" {
  description = "Moid's of the SNMP Policies."
  value = length(local.snmp) > 0 ? { for v in sort(
    keys(intersight_snmp_policy.snmp)
  ) : v => intersight_snmp_policy.snmp[v].moid } : {}
}


#__________________________________________________________
#
# SSH Policy Outputs
#__________________________________________________________

output "ssh" {
  description = "Moid's of the SSH Policies."
  value = length(lookup(local.policies, "ssh", [])) > 0 ? { for v in sort(
    keys(intersight_ssh_policy.ssh)
  ) : v => intersight_ssh_policy.ssh[v].moid } : {}
}


#__________________________________________________________
#
# Storage Policy Outputs
#__________________________________________________________

output "storage" {
  description = "Moid's of the Storage Policies."
  value = length(local.storage) > 0 ? { for v in sort(
    keys(intersight_storage_storage_policy.storage)
  ) : v => intersight_storage_storage_policy.storage[v].moid } : {}
}


#__________________________________________________________
#
# Switch Control Policy Outputs
#__________________________________________________________

output "switch_control" {
  description = "Moid's of the Switch Control Policies."
  value = length(local.switch_control) > 0 ? { for v in sort(
    keys(intersight_fabric_switch_control_policy.switch_control)
  ) : v => intersight_fabric_switch_control_policy.switch_control[v].moid } : {}
}


#__________________________________________________________
#
# Syslog Policy Outputs
#__________________________________________________________

output "syslog" {
  description = "Moid's of the Syslog Policies."
  value = length(local.syslog) > 0 ? { for v in sort(
    keys(intersight_syslog_policy.syslog)
  ) : v => intersight_syslog_policy.syslog[v].moid } : {}
}


#__________________________________________________________
#
# System QoS Policy Outputs
#__________________________________________________________

output "system_qos" {
  description = "Moid's of the System QoS Policies."
  value = length(local.system_qos) > 0 ? { for v in sort(
    keys(intersight_fabric_system_qos_policy.system_qos)
  ) : v => intersight_fabric_system_qos_policy.system_qos[v].moid } : {}
}


#__________________________________________________________
#
# Thermal Policy Outputs
#__________________________________________________________

output "thermal" {
  description = "Moid's of the Thermal Policies."
  value = length(lookup(local.policies, "thermal", [])) > 0 ? { for v in sort(
    keys(intersight_thermal_policy.thermal)
  ) : v => intersight_thermal_policy.thermal[v].moid } : {}
}


#__________________________________________________________
#
# Virtual KVM Policy Outputs
#__________________________________________________________

output "virtual_kvm" {
  description = "Moid's of the Virtual KVM Policies."
  value = length(lookup(local.policies, "virtual_kvm", [])) > 0 ? { for v in sort(
    keys(intersight_kvm_policy.virtual_kvm)
  ) : v => intersight_kvm_policy.virtual_kvm[v].moid } : {}
}


#__________________________________________________________
#
# Virtual Media Policy Outputs
#__________________________________________________________

output "virtual_media" {
  description = "Moid's of the Virtual Media Policies."
  value = length(local.virtual_media) > 0 ? { for v in sort(
    keys(intersight_vmedia_policy.virtual_media)
  ) : v => intersight_vmedia_policy.virtual_media[v].moid } : {}
}


#__________________________________________________________
#
# VLAN Policy Outputs
#__________________________________________________________

output "vlan" {
  description = "Moid's of the VLAN Policies."
  value = length(local.vlan) > 0 ? { for v in sort(
    keys(intersight_fabric_eth_network_policy.vlan)
  ) : v => intersight_fabric_eth_network_policy.vlan[v].moid } : {}
}


#__________________________________________________________
#
# VSAN Policy Outputs
#__________________________________________________________

output "vsan" {
  description = "Moid's of the VSAN Policies."
  value = length(local.vsan) > 0 ? { for v in sort(
    keys(intersight_fabric_fc_network_policy.vsan)
  ) : v => intersight_fabric_fc_network_policy.vsan[v].moid } : {}
}
