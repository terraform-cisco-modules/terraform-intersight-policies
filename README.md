<!-- BEGIN_TF_DOCS -->
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Developed by: Cisco](https://img.shields.io/badge/Developed%20by-Cisco-blue)](https://developer.cisco.com)

# Terraform Intersight Policies Module

A Terraform module to configure Intersight Policies.

This module is part of the Cisco [*Intersight as Code*](https://cisco.com/go/intersightascode) project. Its goal is to allow users to instantiate network fabrics in minutes using an easy to use, opinionated data model. It takes away the complexity of having to deal with references, dependencies or loops. By completely separating data (defining variables) from logic (infrastructure declaration), it allows the user to focus on describing the intended configuration while using a set of maintained and tested Terraform Modules without the need to understand the low-level Intersight object model.

A comprehensive example using this module is available here: https://github.com/terraform-cisco-modules/iac-intersight-comprehensive-example

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.0 |
| <a name="requirement_intersight"></a> [intersight](#requirement\_intersight) | >=1.0.37 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_intersight"></a> [intersight](#provider\_intersight) | 1.0.37 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_moids_policies"></a> [moids\_policies](#input\_moids\_policies) | Flag to Determine if Policies Should be associated using resource or data object. | `bool` | `false` | no |
| <a name="input_moids_pools"></a> [moids\_pools](#input\_moids\_pools) | Flag to Determine if Pools Should be associated using data object or from var.pools. | `bool` | `false` | no |
| <a name="input_organization"></a> [organization](#input\_organization) | Name of the default intersight Organization. | `string` | `"default"` | no |
| <a name="input_orgs"></a> [orgs](#input\_orgs) | Input orgs List. | `any` | n/a | yes |
| <a name="input_policies"></a> [policies](#input\_policies) | Policies - YAML to HCL data. | `any` | n/a | yes |
| <a name="input_pools"></a> [pools](#input\_pools) | Pool Moids. | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | List of Key/Value Pairs to Assign as Attributes to the Policy. | `list(map(string))` | `[]` | no |
| <a name="input_certificate_management"></a> [certificate\_management](#input\_certificate\_management) | Note: Sensitive Variables cannot be added to a for\_each loop so these are added seperately.<br>    * certificate: The IMC or Root CA (KMIP) Certificate in PEM Format.<br>    * private\_key: The IMC Private Key in PEM Format. | <pre>object({<br>    certificate = map(string)<br>    private_key = map(string)<br>  })</pre> | <pre>{<br>  "certificate": {},<br>  "private_key": {}<br>}</pre> | no |
| <a name="input_drive_security"></a> [drive\_security](#input\_drive\_security) | * password: Drive Security User Password(s).<br>    * server\_public\_root\_ca\_certificate: The root certificate from the KMIP server. | <pre>object({<br>    password                          = map(string)<br>    server_public_root_ca_certificate = map(string)<br>  })</pre> | <pre>{<br>  "password": {},<br>  "server_public_root_ca_certificate": {}<br>}</pre> | no |
| <a name="input_firmware"></a> [firmware](#input\_firmware) | Note: Sensitive Variables cannot be added to a for\_each loop so these are added seperately.<br>    * cco\_password: The User Password with Permissions to download the Software from cisco.com.<br>    * cco\_user: The User with Permissions to download the Software from cisco.com. | <pre>object({<br>    cco_password = map(string)<br>    cco_user     = map(string)<br>  })</pre> | <pre>{<br>  "cco_password": {},<br>  "cco_user": {}<br>}</pre> | no |
| <a name="input_model"></a> [model](#input\_model) | description = <<-EOT<br>The server family that will be impacted by this upgrade.<br>* UCSC-C220-M4 - The upgrade on all C220-M4 servers claimed in setup.<br>* UCSC-C240-M4 - The upgrade on all C240-M4 servers claimed in setup.<br>* UCSC-C460-M4 - The upgrade on all C460-M4 servers claimed in setup.<br>* UCSB-B200-M5 - The upgrade on all B200-M5 servers claimed in setup.<br>* UCSB-B480-M5 - The upgrade on all B480-M5 servers claimed in setup.<br>* UCSC-C220-M5 - The upgrade on all C220-M5 servers claimed in setup.<br>* UCSC-C240-M5 - The upgrade on all C240-M5 servers claimed in setup.<br>* UCSC-C480-M5 - The upgrade on all C480-M5 servers claimed in setup.<br>* UCSB-B200-M6 - The upgrade on all B200-M6 servers claimed in setup.<br>* UCSC-C220-M6 - The upgrade on all C220-M6 servers claimed in setup.<br>* UCSC-C225-M6 - The upgrade on all C225-M6 servers claimed in setup.<br>* UCSC-C240-M6 - The upgrade on all C240-M6 servers claimed in setup.<br>* UCSC-C245-M6 - The upgrade on all C245-M6 servers claimed in setup.<br>* UCSX-210C-M6 - The upgrade on all 210C-M6 servers claimed in setup.<br>* UCSX-210C-M7 - The upgrade on all 210C-M7 servers claimed in setup.<br>* UCSX-220-M7 - The upgrade on all C220-M7 servers claimed in setup.<br>* UCSX-240-M7 - The upgrade on all C240-M7 servers claimed in setup.<br>* UCSC-C125 - The upgrade on all C125 servers claimed in setup. | `string` | `"UCSX-210C-M7"` | no |
| <a name="input_ipmi_over_lan"></a> [ipmi\_over\_lan](#input\_ipmi\_over\_lan) | Note: Sensitive Variables cannot be added to a for\_each loop so these are added seperately.<br>Encryption Key to use for IPMI Communication.<br>It should have an even number of hexadecimal characters and not exceed 40 characters. | `object({ encryption_key = map(string) })` | <pre>{<br>  "encryption_key": {}<br>}</pre> | no |
| <a name="input_iscsi_boot"></a> [iscsi\_boot](#input\_iscsi\_boot) | Map of iSCSI Boot Password(s) if utilizing Authentication to the Storage Array. | `object({ password = map(string) })` | <pre>{<br>  "password": {}<br>}</pre> | no |
| <a name="input_ldap"></a> [ldap](#input\_ldap) | Note: Sensitive Variables cannot be added to a for\_each loop so these are added seperately.<br>Map of Binding Parameters Password(s)<br>It can be any string that adheres to the following constraints. It can have character except spaces, tabs, line breaks. It cannot be more than 254 characters. | `object({ password = map(string) })` | <pre>{<br>  "password": {}<br>}</pre> | no |
| <a name="input_local_user"></a> [local\_user](#input\_local\_user) | Map of Local User Password(s).  Note: Sensitive Variables cannot be added to a for\_each loop so these are added seperately. | `object({ password = map(string) })` | <pre>{<br>  "password": {}<br>}</pre> | no |
| <a name="input_persistent_memory"></a> [persistent\_memory](#input\_persistent\_memory) | Note: Sensitive Variables cannot be added to a for\_each loop so these are added seperately.<br>    Secure passphrase to be applied on the Persistent Memory Modules on the server. The allowed characters are:<br>    * `a-z`, `A-Z`, `0-9` and special characters: `\u0021`,` &`, `#`, `$`, `%`, `+`, `^`, `@`, `_`, `*`, `-`. | `object({ passphrase = map(string) })` | <pre>{<br>  "passphrase": {}<br>}</pre> | no |
| <a name="input_snmp"></a> [snmp](#input\_snmp) | Note: Sensitive Variables cannot be added to a for\_each loop so these are added seperately.<br>    * access\_community\_string: The default SNMPv1, SNMPv2c community name or SNMPv3 username to include on any trap messages sent to the SNMP host. The name can be 18 characters long.<br>    * auth\_password: Authorization password for the user.<br>    * privacy\_password: Privacy password for the user.<br>    * trap\_community\_string: SNMP community group used for sending SNMP trap to other devices. Valid only for SNMPv2c users. | <pre>object({<br>    access_community_string = map(string)<br>    auth_password           = map(string)<br>    privacy_password        = map(string)<br>    trap_community_string   = map(string)<br>  })</pre> | <pre>{<br>  "access_community_string": {},<br>  "auth_password": {},<br>  "privacy_password": {},<br>  "trap_community_string": {}<br>}</pre> | no |
| <a name="input_virtual_media"></a> [virtual\_media](#input\_virtual\_media) | Note: Sensitive Variables cannot be added to a for\_each loop so these are added seperately.<br>Map of vMedia Passwords when Needed for Server Authentication. | `object({ password = map(string) })` | <pre>{<br>  "password": {}<br>}</pre> | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_adapter_configuration"></a> [adapter\_configuration](#output\_adapter\_configuration) | Moid's of the Adapter Configuration Policies. |
| <a name="output_bios"></a> [bios](#output\_bios) | Moid's of the BIOS Policies. |
| <a name="output_boot_order"></a> [boot\_order](#output\_boot\_order) | Moid's of the Boot Order Policies. |
| <a name="output_certificate_management"></a> [certificate\_management](#output\_certificate\_management) | Moid's of the Certificate Management Policies. |
| <a name="output_device_connector"></a> [device\_connector](#output\_device\_connector) | Moid's of the Device Connector Policies. |
| <a name="output_firmware"></a> [firmware](#output\_firmware) | Moid's of the Firmware Policies. |
| <a name="output_imc_access"></a> [imc\_access](#output\_imc\_access) | Moid's of the IMC Access Policies. |
| <a name="output_ipmi_over_lan"></a> [ipmi\_over\_lan](#output\_ipmi\_over\_lan) | Moid's of the IPMI over LAN Policies. |
| <a name="output_lan_connectivity"></a> [lan\_connectivity](#output\_lan\_connectivity) | Moid's of the LAN Connectivity Policies. |
| <a name="output_ldap"></a> [ldap](#output\_ldap) | Moid's of the LDAP Policies. |
| <a name="output_local_user"></a> [local\_user](#output\_local\_user) | Moid's of the Local User Policies. |
| <a name="output_network_connectivity"></a> [network\_connectivity](#output\_network\_connectivity) | Moid's of the Network Connectivity Policies. |
| <a name="output_ntp"></a> [ntp](#output\_ntp) | Moid's of the NTP Policies. |
| <a name="output_persistent_memory"></a> [persistent\_memory](#output\_persistent\_memory) | Moid's of the Persistent Memory Policies. |
| <a name="output_port"></a> [port](#output\_port) | Moid's of the Port Policies. |
| <a name="output_power"></a> [power](#output\_power) | Moid's of the Power Policies. |
| <a name="output_san_connectivity"></a> [san\_connectivity](#output\_san\_connectivity) | Moid's of the SAN Connectivity Policies. |
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
| [intersight_fabric_link_aggregation_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_link_aggregation_policy) | resource |
| [intersight_fabric_link_control_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_link_control_policy) | resource |
| [intersight_fabric_multicast_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_multicast_policy) | resource |
| [intersight_fabric_port_mode.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_port_mode) | resource |
| [intersight_fabric_port_policy.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_port_policy) | resource |
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
| [intersight_search_search_item.ethernet_adapter](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.ethernet_network](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.ethernet_network_control](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.ethernet_network_group](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.ethernet_qos](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.fc_zone](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.fibre_channel_adapter](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.fibre_channel_network](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.fibre_channel_qos](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.flow_control](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.ip](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.iqn](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.iscsi_adapter](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.iscsi_boot](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.iscsi_static_target](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.link_aggregation](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.link_control](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.mac](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.multicast](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.wwnn](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.wwpn](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
<!-- END_TF_DOCS -->