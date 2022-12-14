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
| <a name="requirement_intersight"></a> [intersight](#requirement\_intersight) | >=1.0.34 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_intersight"></a> [intersight](#provider\_intersight) | >=1.0.34 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_model"></a> [model](#input\_model) | Model data. | `any` | n/a | yes |
| <a name="input_domains"></a> [domains](#input\_domains) | Domain Moids. | `any` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | Name of the default intersight Organization. | `string` | `"default"` | no |
| <a name="input_pools"></a> [pools](#input\_pools) | Pool Moids. | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | List of Key/Value Pairs to Assign as Attributes to the Policy. | `list(map(string))` | `[]` | no |
| <a name="input_base64_certificate_1"></a> [base64\_certificate\_1](#input\_base64\_certificate\_1) | The Server Certificate in Base64 format. | `string` | `""` | no |
| <a name="input_base64_certificate_2"></a> [base64\_certificate\_2](#input\_base64\_certificate\_2) | The Server Certificate in Base64 format. | `string` | `""` | no |
| <a name="input_base64_certificate_3"></a> [base64\_certificate\_3](#input\_base64\_certificate\_3) | The Server Certificate in Base64 format. | `string` | `""` | no |
| <a name="input_base64_certificate_4"></a> [base64\_certificate\_4](#input\_base64\_certificate\_4) | The Server Certificate in Base64 format. | `string` | `""` | no |
| <a name="input_base64_certificate_5"></a> [base64\_certificate\_5](#input\_base64\_certificate\_5) | The Server Certificate in Base64 format. | `string` | `""` | no |
| <a name="input_base64_private_key_1"></a> [base64\_private\_key\_1](#input\_base64\_private\_key\_1) | Private Key in Base64 Format. | `string` | `""` | no |
| <a name="input_base64_private_key_2"></a> [base64\_private\_key\_2](#input\_base64\_private\_key\_2) | Private Key in Base64 Format. | `string` | `""` | no |
| <a name="input_base64_private_key_3"></a> [base64\_private\_key\_3](#input\_base64\_private\_key\_3) | Private Key in Base64 Format. | `string` | `""` | no |
| <a name="input_base64_private_key_4"></a> [base64\_private\_key\_4](#input\_base64\_private\_key\_4) | Private Key in Base64 Format. | `string` | `""` | no |
| <a name="input_base64_private_key_5"></a> [base64\_private\_key\_5](#input\_base64\_private\_key\_5) | Private Key in Base64 Format. | `string` | `""` | no |
| <a name="input_ipmi_key_1"></a> [ipmi\_key\_1](#input\_ipmi\_key\_1) | Encryption key 1 to use for IPMI communication. It should have an even number of hexadecimal characters and not exceed 40 characters. | `string` | `""` | no |
| <a name="input_iscsi_boot_password"></a> [iscsi\_boot\_password](#input\_iscsi\_boot\_password) | Password to Assign to the Policy if doing Authentication. | `string` | `""` | no |
| <a name="input_binding_parameters_password"></a> [binding\_parameters\_password](#input\_binding\_parameters\_password) | The password of the user for initial bind process. It can be any string that adheres to the following constraints. It can have character except spaces, tabs, line breaks. It cannot be more than 254 characters. | `string` | `""` | no |
| <a name="input_local_user_password_1"></a> [local\_user\_password\_1](#input\_local\_user\_password\_1) | Password to assign to a local user.  Sensitive Variables cannot be added to a for\_each loop so these are added seperately. | `string` | `""` | no |
| <a name="input_local_user_password_2"></a> [local\_user\_password\_2](#input\_local\_user\_password\_2) | Password to assign to a local user.  Sensitive Variables cannot be added to a for\_each loop so these are added seperately. | `string` | `""` | no |
| <a name="input_local_user_password_3"></a> [local\_user\_password\_3](#input\_local\_user\_password\_3) | Password to assign to a local user.  Sensitive Variables cannot be added to a for\_each loop so these are added seperately. | `string` | `""` | no |
| <a name="input_local_user_password_4"></a> [local\_user\_password\_4](#input\_local\_user\_password\_4) | Password to assign to a local user.  Sensitive Variables cannot be added to a for\_each loop so these are added seperately. | `string` | `""` | no |
| <a name="input_local_user_password_5"></a> [local\_user\_password\_5](#input\_local\_user\_password\_5) | Password to assign to a local user.  Sensitive Variables cannot be added to a for\_each loop so these are added seperately. | `string` | `""` | no |
| <a name="input_persistent_passphrase"></a> [persistent\_passphrase](#input\_persistent\_passphrase) | Secure passphrase to be applied on the Persistent Memory Modules on the server. The allowed characters are:<br>  - a-z, A-Z, 0-9 and special characters: \u0021, &, #, $, %, +, ^, @, \_, *, -. | `string` | `""` | no |
| <a name="input_access_community_string_1"></a> [access\_community\_string\_1](#input\_access\_community\_string\_1) | The default SNMPv1, SNMPv2c community name or SNMPv3 username to include on any trap messages sent to the SNMP host. The name can be 18 characters long. | `string` | `""` | no |
| <a name="input_access_community_string_2"></a> [access\_community\_string\_2](#input\_access\_community\_string\_2) | The default SNMPv1, SNMPv2c community name or SNMPv3 username to include on any trap messages sent to the SNMP host. The name can be 18 characters long. | `string` | `""` | no |
| <a name="input_access_community_string_3"></a> [access\_community\_string\_3](#input\_access\_community\_string\_3) | The default SNMPv1, SNMPv2c community name or SNMPv3 username to include on any trap messages sent to the SNMP host. The name can be 18 characters long. | `string` | `""` | no |
| <a name="input_access_community_string_4"></a> [access\_community\_string\_4](#input\_access\_community\_string\_4) | The default SNMPv1, SNMPv2c community name or SNMPv3 username to include on any trap messages sent to the SNMP host. The name can be 18 characters long. | `string` | `""` | no |
| <a name="input_access_community_string_5"></a> [access\_community\_string\_5](#input\_access\_community\_string\_5) | The default SNMPv1, SNMPv2c community name or SNMPv3 username to include on any trap messages sent to the SNMP host. The name can be 18 characters long. | `string` | `""` | no |
| <a name="input_snmp_auth_password_1"></a> [snmp\_auth\_password\_1](#input\_snmp\_auth\_password\_1) | SNMPv3 User Authentication Password. | `string` | `""` | no |
| <a name="input_snmp_auth_password_2"></a> [snmp\_auth\_password\_2](#input\_snmp\_auth\_password\_2) | SNMPv3 User Authentication Password. | `string` | `""` | no |
| <a name="input_snmp_auth_password_3"></a> [snmp\_auth\_password\_3](#input\_snmp\_auth\_password\_3) | SNMPv3 User Authentication Password. | `string` | `""` | no |
| <a name="input_snmp_auth_password_4"></a> [snmp\_auth\_password\_4](#input\_snmp\_auth\_password\_4) | SNMPv3 User Authentication Password. | `string` | `""` | no |
| <a name="input_snmp_auth_password_5"></a> [snmp\_auth\_password\_5](#input\_snmp\_auth\_password\_5) | SNMPv3 User Authentication Password. | `string` | `""` | no |
| <a name="input_snmp_privacy_password_1"></a> [snmp\_privacy\_password\_1](#input\_snmp\_privacy\_password\_1) | SNMPv3 User Privacy Password. | `string` | `""` | no |
| <a name="input_snmp_privacy_password_2"></a> [snmp\_privacy\_password\_2](#input\_snmp\_privacy\_password\_2) | SNMPv3 User Privacy Password. | `string` | `""` | no |
| <a name="input_snmp_privacy_password_3"></a> [snmp\_privacy\_password\_3](#input\_snmp\_privacy\_password\_3) | SNMPv3 User Privacy Password. | `string` | `""` | no |
| <a name="input_snmp_privacy_password_4"></a> [snmp\_privacy\_password\_4](#input\_snmp\_privacy\_password\_4) | SNMPv3 User Privacy Password. | `string` | `""` | no |
| <a name="input_snmp_privacy_password_5"></a> [snmp\_privacy\_password\_5](#input\_snmp\_privacy\_password\_5) | SNMPv3 User Privacy Password. | `string` | `""` | no |
| <a name="input_snmp_trap_community_1"></a> [snmp\_trap\_community\_1](#input\_snmp\_trap\_community\_1) | Community for a Trap Destination. | `string` | `""` | no |
| <a name="input_snmp_trap_community_2"></a> [snmp\_trap\_community\_2](#input\_snmp\_trap\_community\_2) | Community for a Trap Destination. | `string` | `""` | no |
| <a name="input_snmp_trap_community_3"></a> [snmp\_trap\_community\_3](#input\_snmp\_trap\_community\_3) | Community for a Trap Destination. | `string` | `""` | no |
| <a name="input_snmp_trap_community_4"></a> [snmp\_trap\_community\_4](#input\_snmp\_trap\_community\_4) | Community for a Trap Destination. | `string` | `""` | no |
| <a name="input_snmp_trap_community_5"></a> [snmp\_trap\_community\_5](#input\_snmp\_trap\_community\_5) | Community for a Trap Destination. | `string` | `""` | no |
| <a name="input_trap_community_string"></a> [trap\_community\_string](#input\_trap\_community\_string) | SNMP community group used for sending SNMP trap to other devices. Valid only for SNMPv2c. | `string` | `""` | no |
| <a name="input_trap_community_string_1"></a> [trap\_community\_string\_1](#input\_trap\_community\_string\_1) | The default SNMPv1, SNMPv2c community name or SNMPv3 username to include on any trap messages sent to the SNMP host. The name can be 18 characters long. | `string` | `""` | no |
| <a name="input_trap_community_string_2"></a> [trap\_community\_string\_2](#input\_trap\_community\_string\_2) | The default SNMPv1, SNMPv2c community name or SNMPv3 username to include on any trap messages sent to the SNMP host. The name can be 18 characters long. | `string` | `""` | no |
| <a name="input_trap_community_string_3"></a> [trap\_community\_string\_3](#input\_trap\_community\_string\_3) | The default SNMPv1, SNMPv2c community name or SNMPv3 username to include on any trap messages sent to the SNMP host. The name can be 18 characters long. | `string` | `""` | no |
| <a name="input_trap_community_string_4"></a> [trap\_community\_string\_4](#input\_trap\_community\_string\_4) | The default SNMPv1, SNMPv2c community name or SNMPv3 username to include on any trap messages sent to the SNMP host. The name can be 18 characters long. | `string` | `""` | no |
| <a name="input_trap_community_string_5"></a> [trap\_community\_string\_5](#input\_trap\_community\_string\_5) | The default SNMPv1, SNMPv2c community name or SNMPv3 username to include on any trap messages sent to the SNMP host. The name can be 18 characters long. | `string` | `""` | no |
| <a name="input_vmedia_password_1"></a> [vmedia\_password\_1](#input\_vmedia\_password\_1) | Password for vMedia | `string` | `""` | no |
| <a name="input_vmedia_password_2"></a> [vmedia\_password\_2](#input\_vmedia\_password\_2) | Password for vMedia | `string` | `""` | no |
| <a name="input_vmedia_password_3"></a> [vmedia\_password\_3](#input\_vmedia\_password\_3) | Password for vMedia | `string` | `""` | no |
| <a name="input_vmedia_password_4"></a> [vmedia\_password\_4](#input\_vmedia\_password\_4) | Password for vMedia | `string` | `""` | no |
| <a name="input_vmedia_password_5"></a> [vmedia\_password\_5](#input\_vmedia\_password\_5) | Password for vMedia | `string` | `""` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_adapter_configuration"></a> [adapter\_configuration](#output\_adapter\_configuration) | Moid's of the Adapter Configuration Policies. |
| <a name="output_bios"></a> [bios](#output\_bios) | Moid's of the BIOS Policies. |
| <a name="output_boot_order"></a> [boot\_order](#output\_boot\_order) | Moid's of the Boot Order Policies. |
| <a name="output_certificate_management"></a> [certificate\_management](#output\_certificate\_management) | Moid's of the Certificate Management Policies. |
| <a name="output_device_connector"></a> [device\_connector](#output\_device\_connector) | Moid's of the Device Connector Policies. |
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
| [intersight_access_policy.imc_access](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/access_policy) | resource |
| [intersight_adapter_config_policy.adapter_configuration](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/adapter_config_policy) | resource |
| [intersight_bios_policy.bios](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/bios_policy) | resource |
| [intersight_boot_precision_policy.boot_order](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/boot_precision_policy) | resource |
| [intersight_certificatemanagement_policy.certificate_management](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/certificatemanagement_policy) | resource |
| [intersight_deviceconnector_policy.device_connector](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/deviceconnector_policy) | resource |
| [intersight_fabric_appliance_pc_role.port_channel_appliances](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_appliance_pc_role) | resource |
| [intersight_fabric_appliance_role.port_role_appliances](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_appliance_role) | resource |
| [intersight_fabric_eth_network_control_policy.ethernet_network_control](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_eth_network_control_policy) | resource |
| [intersight_fabric_eth_network_group_policy.ethernet_network_group](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_eth_network_group_policy) | resource |
| [intersight_fabric_eth_network_policy.vlan](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_eth_network_policy) | resource |
| [intersight_fabric_fc_network_policy.vsan](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_fc_network_policy) | resource |
| [intersight_fabric_fc_storage_role.port_role_fc_storage](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_fc_storage_role) | resource |
| [intersight_fabric_fc_uplink_pc_role.port_channel_fc_uplinks](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_fc_uplink_pc_role) | resource |
| [intersight_fabric_fc_uplink_role.port_role_fc_uplinks](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_fc_uplink_role) | resource |
| [intersight_fabric_fc_zone_policy.fc_zone](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_fc_zone_policy) | resource |
| [intersight_fabric_fcoe_uplink_pc_role.port_channel_fcoe_uplinks](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_fcoe_uplink_pc_role) | resource |
| [intersight_fabric_fcoe_uplink_role.port_role_fcoe_uplinks](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_fcoe_uplink_role) | resource |
| [intersight_fabric_flow_control_policy.flow_control](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_flow_control_policy) | resource |
| [intersight_fabric_link_aggregation_policy.link_aggregation](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_link_aggregation_policy) | resource |
| [intersight_fabric_link_control_policy.link_control](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_link_control_policy) | resource |
| [intersight_fabric_multicast_policy.multicast](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_multicast_policy) | resource |
| [intersight_fabric_port_mode.port_modes](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_port_mode) | resource |
| [intersight_fabric_port_policy.port](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_port_policy) | resource |
| [intersight_fabric_server_role.port_role_servers](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_server_role) | resource |
| [intersight_fabric_switch_control_policy.switch_control](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_switch_control_policy) | resource |
| [intersight_fabric_system_qos_policy.system_qos](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_system_qos_policy) | resource |
| [intersight_fabric_uplink_pc_role.port_channel_ethernet_uplinks](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_uplink_pc_role) | resource |
| [intersight_fabric_uplink_role.port_role_ethernet_uplinks](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_uplink_role) | resource |
| [intersight_fabric_vlan.vlans](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_vlan) | resource |
| [intersight_fabric_vsan.vsans](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_vsan) | resource |
| [intersight_iam_end_point_user.users](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/iam_end_point_user) | resource |
| [intersight_iam_end_point_user_policy.local_user](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/iam_end_point_user_policy) | resource |
| [intersight_iam_end_point_user_role.user_role](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/iam_end_point_user_role) | resource |
| [intersight_iam_ldap_group.ldap_group](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/iam_ldap_group) | resource |
| [intersight_iam_ldap_policy.ldap](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/iam_ldap_policy) | resource |
| [intersight_iam_ldap_provider.ldap_providers](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/iam_ldap_provider) | resource |
| [intersight_ipmioverlan_policy.ipmi_over_lan](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/ipmioverlan_policy) | resource |
| [intersight_kvm_policy.virtual_kvm](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/kvm_policy) | resource |
| [intersight_memory_persistent_memory_policy.persistent_memory](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/memory_persistent_memory_policy) | resource |
| [intersight_networkconfig_policy.network_connectivity](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/networkconfig_policy) | resource |
| [intersight_ntp_policy.ntp](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/ntp_policy) | resource |
| [intersight_power_policy.power](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/power_policy) | resource |
| [intersight_sdcard_policy.sd_card](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/sdcard_policy) | resource |
| [intersight_smtp_policy.smtp](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/smtp_policy) | resource |
| [intersight_snmp_policy.snmp](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/snmp_policy) | resource |
| [intersight_sol_policy.serial_over_lan](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/sol_policy) | resource |
| [intersight_ssh_policy.ssh](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/ssh_policy) | resource |
| [intersight_storage_drive_group.drive_groups](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/storage_drive_group) | resource |
| [intersight_storage_storage_policy.storage](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/storage_storage_policy) | resource |
| [intersight_syslog_policy.syslog](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/syslog_policy) | resource |
| [intersight_thermal_policy.thermal](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/thermal_policy) | resource |
| [intersight_vmedia_policy.virtual_media](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vmedia_policy) | resource |
| [intersight_vnic_eth_adapter_policy.ethernet_adapter](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_eth_adapter_policy) | resource |
| [intersight_vnic_eth_if.vnics](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_eth_if) | resource |
| [intersight_vnic_eth_network_policy.ethernet_network](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_eth_network_policy) | resource |
| [intersight_vnic_eth_qos_policy.ethernet_qos](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_eth_qos_policy) | resource |
| [intersight_vnic_fc_adapter_policy.fibre_channel_adapter](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_fc_adapter_policy) | resource |
| [intersight_vnic_fc_if.vhbas](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_fc_if) | resource |
| [intersight_vnic_fc_network_policy.fibre_channel_network](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_fc_network_policy) | resource |
| [intersight_vnic_fc_qos_policy.fibre_channel_qos](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_fc_qos_policy) | resource |
| [intersight_vnic_iscsi_adapter_policy.iscsi_adapter](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_iscsi_adapter_policy) | resource |
| [intersight_vnic_iscsi_boot_policy.iscsi_boot](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_iscsi_boot_policy) | resource |
| [intersight_vnic_iscsi_static_target_policy.iscsi_static_target](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_iscsi_static_target_policy) | resource |
| [intersight_vnic_lan_connectivity_policy.lan_connectivity](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_lan_connectivity_policy) | resource |
| [intersight_vnic_san_connectivity_policy.san_connectivity](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_san_connectivity_policy) | resource |
| [intersight_iam_end_point_role.roles](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/iam_end_point_role) | data source |
<!-- END_TF_DOCS -->