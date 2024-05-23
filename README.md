<!-- BEGIN_TF_DOCS -->
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Developed by: Cisco](https://img.shields.io/badge/Developed%20by-Cisco-blue)](https://developer.cisco.com)

# Terraform Intersight - Policies Module

A Terraform module to configure Intersight Infrastructure Policies.

### NOTE: THIS MODULE IS DESIGNED TO BE CONSUMED USING "EASY IMM"

### A comprehensive example using this module is available below:

## [Easy IMM](https://github.com/terraform-cisco-modules/easy-imm)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.0 |
| <a name="requirement_intersight"></a> [intersight](#requirement\_intersight) | >=1.0.41 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_intersight"></a> [intersight](#provider\_intersight) | 1.0.48 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_global_settings"></a> [global\_settings](#input\_global\_settings) | YAML to HCL Data - global\_settings. | `any` | n/a | yes |
| <a name="input_model"></a> [model](#input\_model) | YAML to HCL Data - model. | `any` | n/a | yes |
| <a name="input_orgs"></a> [orgs](#input\_orgs) | Intersight Organizations Moid Data. | `any` | n/a | yes |
| <a name="input_pools"></a> [pools](#input\_pools) | Pools - Module Output. | `any` | n/a | yes |
| <a name="input_policies_sensitive"></a> [policies\_sensitive](#input\_policies\_sensitive) | Note: Sensitive Variables cannot be added to a for\_each loop so these are added seperately.<br>certificate\_management:<br>  * certificate: The IMC or Root CA (KMIP) Certificate in PEM Format.<br>  * private\_key: The IMC Private Key in PEM Format.<br>drive\_security:<br>  * password: Drive Security User Password(s).<br>  * server\_public\_root\_ca\_certificate: The root certificate from the KMIP server.<br>firmware:<br>  * cco\_password: The User Password with Permissions to download the Software from cisco.com.<br>  * cco\_user: The User with Permissions to download the Software from cisco.com.<br>ipmi\_over\_lan:<br>  * encrypt\_key:  Encryption Key to use for IPMI Communication.<br>    It should have an even number of hexadecimal characters and not exceed 40 characters.<br>iscsi\_boot:<br>  * password: Map of iSCSI Boot Password(s) if utilizing Authentication to the Storage Array.<br>ldap:<br>  * password: Map of Binding Parameters Password(s).  It can be any string that adheres to the following constraints:<br>    - It can have character except spaces, tabs, line breaks.<br>    - It cannot be more than 254 characters.<br>local\_user:<br>  * password: Map of Local User Password(s).<br>persistent\_memory:<br>  * password: Secure passphrase to be applied on the Persistent Memory Modules on the server. The allowed characters are:<br>    - `a-z`, `A-Z`, `0-9` and special characters: `\u0021`,` &`, `#`, `$`, `%`, `+`, `^`, `@`, `_`, `*`, `-`.<br>snmp:<br>  * access\_community\_string: The default SNMPv1, SNMPv2c community name or SNMPv3 username to include on any trap messages sent to the SNMP host. The name can be 18 characters long.<br>  * auth\_password: Authorization password for the user.<br>  * privacy\_password: Privacy password for the user.<br>  * trap\_community\_string: SNMP community group used for sending SNMP trap to other devices. Valid only for SNMPv2c users.<br>virtual\_media:<br>  * password: Map of vMedia Passwords when Needed for Server Authentication. | <pre>object({<br>    certificate_management = object({<br>      certificate = map(string)<br>      private_key = map(string)<br>    })<br>    drive_security = object({<br>      password                          = map(string)<br>      server_public_root_ca_certificate = map(string)<br>    })<br>    firmware = object({<br>      cco_password = map(string)<br>      cco_user     = map(string)<br>    })<br>    ipmi_over_lan = object({<br>      encryption_key = map(string)<br>    })<br>    iscsi_boot = object({<br>      password = map(string)<br>    })<br>    ldap = object({<br>      password = map(string)<br>    })<br>    local_user = object({<br>      password = map(string)<br>    })<br>    persistent_memory = object({<br>      passphrase = map(string)<br>    })<br>    snmp = object({<br>      access_community_string = map(string)<br>      auth_password           = map(string)<br>      privacy_password        = map(string)<br>      trap_community_string   = map(string)<br>    })<br>    virtual_media = object({<br>      password = map(string)<br>    })<br>  })</pre> | <pre>{<br>  "certificate_management": {<br>    "certificate": {},<br>    "private_key": {}<br>  },<br>  "drive_security": {<br>    "password": {},<br>    "server_public_root_ca_certificate": {}<br>  },<br>  "firmware": {<br>    "cco_password": {},<br>    "cco_user": {}<br>  },<br>  "ipmi_over_lan": {<br>    "encryption_key": {}<br>  },<br>  "iscsi_boot": {<br>    "password": {}<br>  },<br>  "ldap": {<br>    "password": {}<br>  },<br>  "local_user": {<br>    "password": {}<br>  },<br>  "persistent_memory": {<br>    "passphrase": {}<br>  },<br>  "snmp": {<br>    "access_community_string": {},<br>    "auth_password": {},<br>    "privacy_password": {},<br>    "trap_community_string": {}<br>  },<br>  "virtual_media": {<br>    "password": {}<br>  }<br>}</pre> | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_data_policies"></a> [data\_policies](#output\_data\_policies) | Moid's of the Policies that were not defined locally. |
| <a name="output_data_pools"></a> [data\_pools](#output\_data\_pools) | Moid's of the Pools that were not defined locally. |
| <a name="output_name_prefix"></a> [name\_prefix](#output\_name\_prefix) | Name Prefix Outputs. |
| <a name="output_name_suffix"></a> [name\_suffix](#output\_name\_suffix) | Name Suffix Outputs. |
| <a name="output_adapter_configuration"></a> [adapter\_configuration](#output\_adapter\_configuration) | Moid's of the Adapter Configuration Policies. |
| <a name="output_bios"></a> [bios](#output\_bios) | Moid's of the BIOS Policies. |
| <a name="output_boot_order"></a> [boot\_order](#output\_boot\_order) | Moid's of the Boot Order Policies. |
| <a name="output_certificate_management"></a> [certificate\_management](#output\_certificate\_management) | Moid's of the Certificate Management Policies. |
| <a name="output_device_connector"></a> [device\_connector](#output\_device\_connector) | Moid's of the Device Connector Policies. |
| <a name="output_drive_security"></a> [drive\_security](#output\_drive\_security) | Moid's of the Drive Security Policies. |
| <a name="output_ethernet_adapter"></a> [ethernet\_adapter](#output\_ethernet\_adapter) | Moid's of the Ethernet Adapter Policies. |
| <a name="output_ethernet_network"></a> [ethernet\_network](#output\_ethernet\_network) | Moid's of the Ethernet Network Policies. |
| <a name="output_ethernet_network_control"></a> [ethernet\_network\_control](#output\_ethernet\_network\_control) | Moid's of the Ethernet Network Control Policies. |
| <a name="output_ethernet_network_group"></a> [ethernet\_network\_group](#output\_ethernet\_network\_group) | Moid's of the Ethernet Network Group Policies. |
| <a name="output_ethernet_qos"></a> [ethernet\_qos](#output\_ethernet\_qos) | Moid's of the Ethernet QoS Policies. |
| <a name="output_fc_zone"></a> [fc\_zone](#output\_fc\_zone) | Moid's of the FC Zone Policies. |
| <a name="output_fibre_channel_adapter"></a> [fibre\_channel\_adapter](#output\_fibre\_channel\_adapter) | Moid's of the Fibre Channel Adapter Policies. |
| <a name="output_fibre_channel_network"></a> [fibre\_channel\_network](#output\_fibre\_channel\_network) | Moid's of the Fibre Channel Network Policies. |
| <a name="output_fibre_channel_qos"></a> [fibre\_channel\_qos](#output\_fibre\_channel\_qos) | Moid's of the Fibre Channel QoS Policies. |
| <a name="output_flow_control"></a> [flow\_control](#output\_flow\_control) | Moid's of the Flow Control Policies. |
| <a name="output_firmware"></a> [firmware](#output\_firmware) | Moid's of the Firmware Policies. |
| <a name="output_imc_access"></a> [imc\_access](#output\_imc\_access) | Moid's of the IMC Access Policies. |
| <a name="output_ipmi_over_lan"></a> [ipmi\_over\_lan](#output\_ipmi\_over\_lan) | Moid's of the IPMI over LAN Policies. |
| <a name="output_iscsi_adapter"></a> [iscsi\_adapter](#output\_iscsi\_adapter) | Moid's of the iSCSI Adapter Policies. |
| <a name="output_iscsi_boot"></a> [iscsi\_boot](#output\_iscsi\_boot) | Moid's of the iSCSI Boot Policies. |
| <a name="output_iscsi_static_target"></a> [iscsi\_static\_target](#output\_iscsi\_static\_target) | Moid's of the iSCSI Static Target Policies. |
| <a name="output_lan_connectivity"></a> [lan\_connectivity](#output\_lan\_connectivity) | Moid's of the LAN Connectivity Policies. |
| <a name="output_lan_connectivity_vnics"></a> [lan\_connectivity\_vnics](#output\_lan\_connectivity\_vnics) | Moid's of the LAN Connectivity - VNICs Policies. |
| <a name="output_link_aggregation"></a> [link\_aggregation](#output\_link\_aggregation) | Moid's of the Link Control Policies. |
| <a name="output_link_control"></a> [link\_control](#output\_link\_control) | Moid's of the Link Control Policies. |
| <a name="output_ldap"></a> [ldap](#output\_ldap) | Moid's of the LDAP Policies. |
| <a name="output_local_user"></a> [local\_user](#output\_local\_user) | Moid's of the Local User Policies. |
| <a name="output_multicast"></a> [multicast](#output\_multicast) | Moid's of the Multicast Policies. |
| <a name="output_network_connectivity"></a> [network\_connectivity](#output\_network\_connectivity) | Moid's of the Network Connectivity Policies. |
| <a name="output_ntp"></a> [ntp](#output\_ntp) | Moid's of the NTP Policies. |
| <a name="output_persistent_memory"></a> [persistent\_memory](#output\_persistent\_memory) | Moid's of the Persistent Memory Policies. |
| <a name="output_port"></a> [port](#output\_port) | Moid's of the Port Policies. |
| <a name="output_ports"></a> [ports](#output\_ports) | Moid's of the Port Child Policies. |
| <a name="output_power"></a> [power](#output\_power) | Moid's of the Power Policies. |
| <a name="output_san_connectivity"></a> [san\_connectivity](#output\_san\_connectivity) | Moid's of the SAN Connectivity Policies. |
| <a name="output_san_connectivity_vhbas"></a> [san\_connectivity\_vhbas](#output\_san\_connectivity\_vhbas) | Moid's of the SAN Connectivity - VHBAs Policies. |
| <a name="output_sd_card"></a> [sd\_card](#output\_sd\_card) | Moid's of the SD Card Policies. |
| <a name="output_serial_over_lan"></a> [serial\_over\_lan](#output\_serial\_over\_lan) | Moid's of the Serial over LAN Policies. |
| <a name="output_smtp"></a> [smtp](#output\_smtp) | Moid's of the SMTP Policies. |
| <a name="output_snmp"></a> [snmp](#output\_snmp) | Moid's of the SNMP Policies. |
| <a name="output_ssh"></a> [ssh](#output\_ssh) | Moid's of the SSH Policies. |
| <a name="output_storage"></a> [storage](#output\_storage) | Moid's of the Storage Policies. |
| <a name="output_switch_control"></a> [switch\_control](#output\_switch\_control) | Moid's of the Switch Control Policies. |
| <a name="output_syslog"></a> [syslog](#output\_syslog) | Moid's of the Syslog Policies. |
| <a name="output_system_qos"></a> [system\_qos](#output\_system\_qos) | Moid's of the System QoS Policies. |
| <a name="output_thermal"></a> [thermal](#output\_thermal) | Moid's of the Thermal Policies. |
| <a name="output_virtual_kvm"></a> [virtual\_kvm](#output\_virtual\_kvm) | Moid's of the Virtual KVM Policies. |
| <a name="output_virtual_media"></a> [virtual\_media](#output\_virtual\_media) | Moid's of the Virtual Media Policies. |
| <a name="output_vlan"></a> [vlan](#output\_vlan) | Moid's of the VLAN Policies. |
| <a name="output_vsan"></a> [vsan](#output\_vsan) | Moid's of the VSAN Policies. |
## Resources

| Name | Type |
|------|------|
| [intersight_access_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/access_policy) | resource |
| [intersight_adapter_config_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/adapter_config_policy) | resource |
| [intersight_bios_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/bios_policy) | resource |
| [intersight_boot_precision_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/boot_precision_policy) | resource |
| [intersight_certificatemanagement_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/certificatemanagement_policy) | resource |
| [intersight_deviceconnector_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/deviceconnector_policy) | resource |
| [intersight_fabric_appliance_pc_role.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_appliance_pc_role) | resource |
| [intersight_fabric_appliance_role.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_appliance_role) | resource |
| [intersight_fabric_eth_network_control_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_eth_network_control_policy) | resource |
| [intersight_fabric_eth_network_group_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_eth_network_group_policy) | resource |
| [intersight_fabric_eth_network_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_eth_network_policy) | resource |
| [intersight_fabric_fc_network_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_fc_network_policy) | resource |
| [intersight_fabric_fc_storage_role.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_fc_storage_role) | resource |
| [intersight_fabric_fc_uplink_pc_role.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_fc_uplink_pc_role) | resource |
| [intersight_fabric_fc_uplink_role.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_fc_uplink_role) | resource |
| [intersight_fabric_fc_zone_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_fc_zone_policy) | resource |
| [intersight_fabric_fcoe_uplink_pc_role.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_fcoe_uplink_pc_role) | resource |
| [intersight_fabric_fcoe_uplink_role.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_fcoe_uplink_role) | resource |
| [intersight_fabric_flow_control_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_flow_control_policy) | resource |
| [intersight_fabric_lan_pin_group.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_lan_pin_group) | resource |
| [intersight_fabric_link_aggregation_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_link_aggregation_policy) | resource |
| [intersight_fabric_link_control_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_link_control_policy) | resource |
| [intersight_fabric_multicast_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_multicast_policy) | resource |
| [intersight_fabric_port_mode.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_port_mode) | resource |
| [intersight_fabric_port_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_port_policy) | resource |
| [intersight_fabric_san_pin_group.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_san_pin_group) | resource |
| [intersight_fabric_server_role.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_server_role) | resource |
| [intersight_fabric_switch_control_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_switch_control_policy) | resource |
| [intersight_fabric_system_qos_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_system_qos_policy) | resource |
| [intersight_fabric_uplink_pc_role.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_uplink_pc_role) | resource |
| [intersight_fabric_uplink_role.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_uplink_role) | resource |
| [intersight_fabric_vlan.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_vlan) | resource |
| [intersight_fabric_vsan.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_vsan) | resource |
| [intersight_firmware_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/firmware_policy) | resource |
| [intersight_iam_end_point_user.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/iam_end_point_user) | resource |
| [intersight_iam_end_point_user_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/iam_end_point_user_policy) | resource |
| [intersight_iam_end_point_user_role.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/iam_end_point_user_role) | resource |
| [intersight_iam_ldap_group.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/iam_ldap_group) | resource |
| [intersight_iam_ldap_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/iam_ldap_policy) | resource |
| [intersight_iam_ldap_provider.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/iam_ldap_provider) | resource |
| [intersight_ipmioverlan_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/ipmioverlan_policy) | resource |
| [intersight_kvm_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/kvm_policy) | resource |
| [intersight_memory_persistent_memory_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/memory_persistent_memory_policy) | resource |
| [intersight_networkconfig_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/networkconfig_policy) | resource |
| [intersight_ntp_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/ntp_policy) | resource |
| [intersight_power_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/power_policy) | resource |
| [intersight_sdcard_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/sdcard_policy) | resource |
| [intersight_smtp_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/smtp_policy) | resource |
| [intersight_snmp_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/snmp_policy) | resource |
| [intersight_softwarerepository_authorization.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/softwarerepository_authorization) | resource |
| [intersight_sol_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/sol_policy) | resource |
| [intersight_ssh_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/ssh_policy) | resource |
| [intersight_storage_drive_group.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/storage_drive_group) | resource |
| [intersight_storage_drive_security_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/storage_drive_security_policy) | resource |
| [intersight_storage_storage_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/storage_storage_policy) | resource |
| [intersight_syslog_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/syslog_policy) | resource |
| [intersight_thermal_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/thermal_policy) | resource |
| [intersight_vmedia_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vmedia_policy) | resource |
| [intersight_vnic_eth_adapter_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_eth_adapter_policy) | resource |
| [intersight_vnic_eth_if.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_eth_if) | resource |
| [intersight_vnic_eth_network_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_eth_network_policy) | resource |
| [intersight_vnic_eth_qos_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_eth_qos_policy) | resource |
| [intersight_vnic_fc_adapter_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_fc_adapter_policy) | resource |
| [intersight_vnic_fc_if.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_fc_if) | resource |
| [intersight_vnic_fc_network_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_fc_network_policy) | resource |
| [intersight_vnic_fc_qos_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_fc_qos_policy) | resource |
| [intersight_vnic_iscsi_adapter_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_iscsi_adapter_policy) | resource |
| [intersight_vnic_iscsi_boot_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_iscsi_boot_policy) | resource |
| [intersight_vnic_iscsi_static_target_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_iscsi_static_target_policy) | resource |
| [intersight_vnic_lan_connectivity_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_lan_connectivity_policy) | resource |
| [intersight_vnic_san_connectivity_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_san_connectivity_policy) | resource |
| [intersight_iam_account.account](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/iam_account) | data source |
| [intersight_iam_end_point_role.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/iam_end_point_role) | data source |
| [intersight_search_search_item.policies](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.pools](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
<!-- END_TF_DOCS -->