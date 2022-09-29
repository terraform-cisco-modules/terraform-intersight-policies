#__________________________________________________________
#
# Adapter Configuration Policy Outputs
#__________________________________________________________

output "adapter_configuration" {
  description = "Moid's of the Adapter Configuration Policies."
  value = length(lookup(local.policies, "adapter_configuration", [])) > 0 ? { for v in sort(
    keys(module.adapter_configuration)
  ) : v => module.adapter_configuration[v].moid } : {}
}


#__________________________________________________________
#
# BIOS Policy Outputs
#__________________________________________________________

output "bios" {
  description = "Moid's of the BIOS Policies."
  value = length(lookup(local.policies, "bios", [])) > 0 ? { for v in sort(
    keys(module.bios)
  ) : v => module.bios[v].moid } : {}
}


#__________________________________________________________
#
# Boot Order Policy Outputs
#__________________________________________________________

output "boot_order" {
  description = "Moid's of the Boot Order Policies."
  value = length(lookup(local.policies, "boot_order", [])) > 0 ? { for v in sort(
    keys(module.boot_order)
  ) : v => module.boot_order[v].moid } : {}
}


#__________________________________________________________
#
# Certificate Management Policy Outputs
#__________________________________________________________

output "certificate_management" {
  description = "Moid's of the Certificate Management Policies."
  value = length(lookup(local.policies, "certificate_management", [])) > 0 ? { for v in sort(
    keys(module.certificate_management)
  ) : v => module.certificate_management[v].moid } : {}
}


#__________________________________________________________
#
# Device Connector Policy Outputs
#__________________________________________________________

output "device_connector" {
  description = "Moid's of the Device Connector Policies."
  value = length(lookup(local.policies, "device_connector", [])) > 0 ? { for v in sort(
    keys(module.device_connector)
  ) : v => module.device_connector[v].moid } : {}
}


#__________________________________________________________
#
# IMC Access Policy Outputs
#__________________________________________________________

output "imc_access" {
  description = "Moid's of the IMC Access Policies."
  value = length(lookup(local.policies, "imc_access", [])) > 0 ? { for v in sort(
    keys(module.imc_access)
  ) : v => module.imc_access[v].moid } : {}
}


#__________________________________________________________
#
# IPMI over LAN Policy Outputs
#__________________________________________________________

output "ipmi_over_lan" {
  description = "Moid's of the IPMI over LAN Policies."
  value = length(lookup(local.policies, "ipmi_over_lan", [])) > 0 ? { for v in sort(
    keys(module.ipmi_over_lan)
  ) : v => module.ipmi_over_lan[v].moid } : {}
}


#__________________________________________________________
#
# LAN Connectivity Policy Outputs
#__________________________________________________________

output "lan_connectivity" {
  description = "Moid's of the LAN Connectivity Policies."
  value = length(lookup(local.policies, "lan_connectivity", [])) > 0 ? { for v in sort(
    keys(module.lan_connectivity)
  ) : v => module.lan_connectivity[v].moid } : {}
}

output "lan_policies" {
  value = module.lan_connectivity
}

#__________________________________________________________
#
# LDAP Policy Outputs
#__________________________________________________________

output "ldap" {
  description = "Moid's of the LDAP Policies."
  value = length(lookup(local.policies, "ldap", [])) > 0 ? { for v in sort(
    keys(module.ldap)
  ) : v => module.ldap[v].moid } : {}
}


#__________________________________________________________
#
# Local User Policy Outputs
#__________________________________________________________

output "local_user" {
  description = "Moid's of the Local User Policies."
  value = length(lookup(local.policies, "local_user", [])) > 0 ? { for v in sort(
    keys(module.local_user)
  ) : v => module.local_user[v].moid } : {}
}


#__________________________________________________________
#
# Network Connectivity Policy Outputs
#__________________________________________________________

output "network_connectivity" {
  description = "Moid's of the Network Connectivity Policies."
  value = length(lookup(local.policies, "network_connectivity", [])) > 0 ? { for v in sort(
    keys(module.network_connectivity)
  ) : v => module.network_connectivity[v].moid } : {}
}


#__________________________________________________________
#
# NTP Policy Outputs
#__________________________________________________________

output "ntp" {
  description = "Moid's of the NTP Policies."
  value = length(lookup(local.policies, "ntp", [])) > 0 ? { for v in sort(
    keys(module.ntp)
  ) : v => module.ntp[v].moid } : {}
}


#__________________________________________________________
#
# Persistent Memory Policy Outputs
#__________________________________________________________

#output "persistent_memory" {
#  description = "Moid's of the Persistent Memory Policies."
#  value = length(lookup(local.policies, "persistent_memory", [])) > 0 ? { for v in sort(
#    keys(module.persistent_memory)
#  ) : v => module.persistent_memory[v].moid } : {}
#}


#__________________________________________________________
#
# Port Policy Outputs
#__________________________________________________________

output "port" {
  description = "Moid's of the Port Policies."
  value = length(lookup(local.policies, "port", [])) > 0 ? { for v in sort(
    keys(module.port)
  ) : v => module.port[v].moid } : {}
}


#__________________________________________________________
#
# Power Policy Outputs
#__________________________________________________________

output "power" {
  description = "Moid's of the Power Policies."
  value = length(lookup(local.policies, "power", [])) > 0 ? { for v in sort(
    keys(module.power)
  ) : v => module.power[v].moid } : {}
}


#__________________________________________________________
#
# SAN Connectivity Policy Outputs
#__________________________________________________________

output "san_connectivity" {
  description = "Moid's of the SAN Connectivity Policies."
  value = length(lookup(local.policies, "san_connectivity", [])) > 0 ? { for v in sort(
    keys(module.san_connectivity)
  ) : v => module.san_connectivity[v].moid } : {}
}


#__________________________________________________________
#
# Serial over LAN Policy Outputs
#__________________________________________________________

output "serial_over_lan" {
  description = "Moid's of the Serial over LAN Policies."
  value = length(lookup(local.policies, "serial_over_lan", [])) > 0 ? { for v in sort(
    keys(module.serial_over_lan)
  ) : v => module.serial_over_lan[v].moid } : {}
}


#__________________________________________________________
#
# SMTP Policy Outputs
#__________________________________________________________

output "smtp" {
  description = "Moid's of the SMTP Policies."
  value = length(lookup(local.policies, "smtp", [])) > 0 ? { for v in sort(
    keys(module.smtp)
  ) : v => module.smtp[v].moid } : {}
}


#__________________________________________________________
#
# SNMP Policy Outputs
#__________________________________________________________

output "snmp" {
  description = "Moid's of the SNMP Policies."
  value = length(lookup(local.policies, "snmp", [])) > 0 ? { for v in sort(
    keys(module.snmp)
  ) : v => module.snmp[v].moid } : {}
}


#__________________________________________________________
#
# SSH Policy Outputs
#__________________________________________________________

output "ssh" {
  description = "Moid's of the SSH Policies."
  value = length(lookup(local.policies, "ssh", [])) > 0 ? { for v in sort(
    keys(module.ssh)
  ) : v => module.ssh[v].moid } : {}
}


#__________________________________________________________
#
# Storage Policy Outputs
#__________________________________________________________

output "storage" {
  description = "Moid's of the Storage Policies."
  value = length(lookup(local.policies, "storage", [])) > 0 ? { for v in sort(
    keys(module.storage)
  ) : v => module.storage[v].moid } : {}
}


#__________________________________________________________
#
# Switch Control Policy Outputs
#__________________________________________________________

output "switch_control" {
  description = "Moid's of the Switch Control Policies."
  value = length(lookup(local.policies, "switch_control", [])) > 0 ? { for v in sort(
    keys(module.switch_control)
  ) : v => module.switch_control[v].moid } : {}
}


#__________________________________________________________
#
# Syslog Policy Outputs
#__________________________________________________________

output "syslog" {
  description = "Moid's of the Syslog Policies."
  value = length(lookup(local.policies, "syslog", [])) > 0 ? { for v in sort(
    keys(module.syslog)
  ) : v => module.syslog[v].moid } : {}
}


#__________________________________________________________
#
# System QoS Policy Outputs
#__________________________________________________________

output "system_qos" {
  description = "Moid's of the System QoS Policies."
  value = length(lookup(local.policies, "system_qos", [])) > 0 ? { for v in sort(
    keys(module.system_qos)
  ) : v => module.system_qos[v].moid } : {}
}


#__________________________________________________________
#
# Thermal Policy Outputs
#__________________________________________________________

output "thermal" {
  description = "Moid's of the Thermal Policies."
  value = length(lookup(local.policies, "thermal", [])) > 0 ? { for v in sort(
    keys(module.thermal)
  ) : v => module.thermal[v].moid } : {}
}


#__________________________________________________________
#
# Virtual KVM Policy Outputs
#__________________________________________________________

output "virtual_kvm" {
  description = "Moid's of the Virtual KVM Policies."
  value = length(lookup(local.policies, "virtual_kvm", [])) > 0 ? { for v in sort(
    keys(module.virtual_kvm)
  ) : v => module.virtual_kvm[v].moid } : {}
}


#__________________________________________________________
#
# Virtual Media Policy Outputs
#__________________________________________________________

output "virtual_media" {
  description = "Moid's of the Virtual Media Policies."
  value = length(lookup(local.policies, "virtual_media", [])) > 0 ? { for v in sort(
    keys(module.virtual_media)
  ) : v => module.virtual_media[v].moid } : {}
}


#__________________________________________________________
#
# VLAN Policy Outputs
#__________________________________________________________

output "vlan" {
  description = "Moid's of the VLAN Policies."
  value = length(lookup(local.policies, "vlan", [])) > 0 ? { for v in sort(
    keys(module.vlan)
  ) : v => module.vlan[v].moid } : {}
}


#__________________________________________________________
#
# VSAN Policy Outputs
#__________________________________________________________

output "vsan" {
  description = "Moid's of the VSAN Policies."
  value = length(lookup(local.policies, "vsan", [])) > 0 ? { for v in sort(
    keys(module.vsan)
  ) : v => module.vsan[v].moid } : {}
}
