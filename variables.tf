#__________________________________________________________________
#
# Model Data and policy from domains and pools
#__________________________________________________________________

#variable "defaults" {
#  description = "Map of Defaults for Intersight Profiles."
#  type        = any
#}

variable "moids_policies" {
  default     = false
  description = "Flag to Determine if Policies Should be associated using resource or data object."
  type        = bool
}

variable "moids_pools" {
  default     = false
  description = "Flag to Determine if Pools Should be associated using data object or from var.pools."
  type        = bool
}

variable "organization" {
  default     = "default"
  description = "Name of the default intersight Organization."
  type        = string
}

variable "orgs" {
  description = "Input orgs List."
  type        = any
}

variable "policies" {
  description = "Policies - YAML to HCL data."
  type        = any
}

variable "pools" {
  description = "Pool Moids."
  type        = any
}

variable "tags" {
  default     = []
  description = "List of Key/Value Pairs to Assign as Attributes to the Policy."
  type        = list(map(string))
}

#__________________________________________________________________
#
# Certificate Management Sensitive Variables
#__________________________________________________________________

variable "cert_mgmt_certificate_1" {
  default     = ""
  description = "The Server Certificate in PEM format."
  sensitive   = true
  type        = string
}

variable "cert_mgmt_certificate_2" {
  default     = ""
  description = "The Server Certificate in PEM format."
  sensitive   = true
  type        = string
}

variable "cert_mgmt_certificate_3" {
  default     = ""
  description = "The Server Certificate in PEM format."
  sensitive   = true
  type        = string
}

variable "cert_mgmt_certificate_4" {
  default     = ""
  description = "The Server Certificate in PEM format."
  sensitive   = true
  type        = string
}

variable "cert_mgmt_certificate_5" {
  default     = ""
  description = "The Server Certificate in PEM format."
  sensitive   = true
  type        = string
}

variable "cert_mgmt_private_key_1" {
  default     = ""
  description = "Private Key in PEM Format."
  sensitive   = true
  type        = string
}

variable "cert_mgmt_private_key_2" {
  default     = ""
  description = "Private Key in PEM Format."
  sensitive   = true
  type        = string
}

variable "cert_mgmt_private_key_3" {
  default     = ""
  description = "Private Key in PEM Format."
  sensitive   = true
  type        = string
}

variable "cert_mgmt_private_key_4" {
  default     = ""
  description = "Private Key in PEM Format."
  sensitive   = true
  type        = string
}

variable "cert_mgmt_private_key_5" {
  default     = ""
  description = "Private Key in PEM Format."
  sensitive   = true
  type        = string
}

#__________________________________________________________________
#
# Drive Security Sensitive Variables
#__________________________________________________________________

variable "drive_security_password" {
  default     = ""
  description = "Drive Security User Password."
  sensitive   = true
  type        = string
}

variable "drive_security_server_ca_certificate" {
  default     = ""
  description = "Drive Security Server CA Certificate in PEM Format."
  sensitive   = true
  type        = string
}

#__________________________________________________________________
#
# Firmware Sensitive Variables
#__________________________________________________________________

variable "cco_password" {
  default     = ""
  description = "CCO User Account Password."
  sensitive   = true
  type        = string
}

variable "cco_user" {
  default     = "cco_user"
  description = "CCO User Account Email for Firmware Policies."
  type        = string
}

variable "model" {
  default     = "UCSC-C220-M5"
  description = <<-EOT
    description = <<-EOT
    The server family that will be impacted by this upgrade.
    * UCSC-C220-M4 - The upgrade on all C220-M4 servers claimed in setup.
    * UCSC-C240-M4 - The upgrade on all C240-M4 servers claimed in setup.
    * UCSC-C460-M4 - The upgrade on all C460-M4 servers claimed in setup.
    * UCSB-B200-M5 - The upgrade on all B200-M5 servers claimed in setup.
    * UCSB-B480-M5 - The upgrade on all B480-M5 servers claimed in setup.
    * UCSC-C220-M5 - The upgrade on all C220-M5 servers claimed in setup.
    * UCSC-C240-M5 - The upgrade on all C240-M5 servers claimed in setup.
    * UCSC-C480-M5 - The upgrade on all C480-M5 servers claimed in setup.
    * UCSB-B200-M6 - The upgrade on all B200-M6 servers claimed in setup.
    * UCSC-C220-M6 - The upgrade on all C220-M6 servers claimed in setup.
    * UCSC-C225-M6 - The upgrade on all C225-M6 servers claimed in setup.
    * UCSC-C240-M6 - The upgrade on all C240-M6 servers claimed in setup.
    * UCSC-C245-M6 - The upgrade on all C245-M6 servers claimed in setup.
    * UCSX-210C-M6 - The upgrade on all 210C-M6 servers claimed in setup.
    * UCSX-210C-M7 - The upgrade on all 210C-M7 servers claimed in setup.
    * UCSX-220-M7 - The upgrade on all C220-M7 servers claimed in setup.
    * UCSX-240-M7 - The upgrade on all C240-M7 servers claimed in setup.
    * UCSC-C125 - The upgrade on all C125 servers claimed in setup.
  EOT
  type        = string
}

#__________________________________________________________________
#
# IPMI Sensitive Variables
#__________________________________________________________________

variable "ipmi_key_1" {
  default     = ""
  description = "Encryption key 1 to use for IPMI communication. It should have an even number of hexadecimal characters and not exceed 40 characters."
  sensitive   = true
  type        = string
}

#__________________________________________________________________
#
# iSCSI Boot Sensitive Variable
#__________________________________________________________________

variable "iscsi_boot_password" {
  default     = ""
  description = "Password to Assign to the Policy if doing Authentication."
  sensitive   = true
  type        = string
}

#__________________________________________________________________
#
# LDAP Sensitive Variable
#__________________________________________________________________

variable "binding_parameters_password" {
  default     = ""
  description = "The password of the user for initial bind process. It can be any string that adheres to the following constraints. It can have character except spaces, tabs, line breaks. It cannot be more than 254 characters."
  sensitive   = true
  type        = string
}

#__________________________________________________________________
#
# Local User Sensitive Variables
#__________________________________________________________________

variable "local_user_password_1" {
  default     = ""
  description = "Password to assign to a local user.  Sensitive Variables cannot be added to a for_each loop so these are added seperately."
  sensitive   = true
  type        = string
}

variable "local_user_password_2" {
  default     = ""
  description = "Password to assign to a local user.  Sensitive Variables cannot be added to a for_each loop so these are added seperately."
  sensitive   = true
  type        = string
}

variable "local_user_password_3" {
  default     = ""
  description = "Password to assign to a local user.  Sensitive Variables cannot be added to a for_each loop so these are added seperately."
  sensitive   = true
  type        = string
}

variable "local_user_password_4" {
  default     = ""
  description = "Password to assign to a local user.  Sensitive Variables cannot be added to a for_each loop so these are added seperately."
  sensitive   = true
  type        = string
}

variable "local_user_password_5" {
  default     = ""
  description = "Password to assign to a local user.  Sensitive Variables cannot be added to a for_each loop so these are added seperately."
  sensitive   = true
  type        = string
}

#__________________________________________________________________
#
# Persistent Memory Sensitive Variable
#__________________________________________________________________

variable "persistent_passphrase" {
  default     = ""
  description = <<-EOT
  Secure passphrase to be applied on the Persistent Memory Modules on the server. The allowed characters are:
    - a-z, A-Z, 0-9 and special characters: \u0021, &, #, $, %, +, ^, @, _, *, -.
  EOT
  sensitive   = true
  type        = string
}

#__________________________________________________________________
#
# SNMP Sensitive Variables
#__________________________________________________________________

variable "access_community_string_1" {
  default     = ""
  description = "The default SNMPv1, SNMPv2c community name or SNMPv3 username to include on any trap messages sent to the SNMP host. The name can be 18 characters long."
  sensitive   = true
  type        = string
}

variable "access_community_string_2" {
  default     = ""
  description = "The default SNMPv1, SNMPv2c community name or SNMPv3 username to include on any trap messages sent to the SNMP host. The name can be 18 characters long."
  sensitive   = true
  type        = string
}

variable "access_community_string_3" {
  default     = ""
  description = "The default SNMPv1, SNMPv2c community name or SNMPv3 username to include on any trap messages sent to the SNMP host. The name can be 18 characters long."
  sensitive   = true
  type        = string
}

variable "access_community_string_4" {
  default     = ""
  description = "The default SNMPv1, SNMPv2c community name or SNMPv3 username to include on any trap messages sent to the SNMP host. The name can be 18 characters long."
  sensitive   = true
  type        = string
}

variable "access_community_string_5" {
  default     = ""
  description = "The default SNMPv1, SNMPv2c community name or SNMPv3 username to include on any trap messages sent to the SNMP host. The name can be 18 characters long."
  sensitive   = true
  type        = string
}

variable "snmp_auth_password_1" {
  default     = ""
  description = "SNMPv3 User Authentication Password."
  sensitive   = true
  type        = string
}

variable "snmp_auth_password_2" {
  default     = ""
  description = "SNMPv3 User Authentication Password."
  sensitive   = true
  type        = string
}

variable "snmp_auth_password_3" {
  default     = ""
  description = "SNMPv3 User Authentication Password."
  sensitive   = true
  type        = string
}

variable "snmp_auth_password_4" {
  default     = ""
  description = "SNMPv3 User Authentication Password."
  sensitive   = true
  type        = string
}

variable "snmp_auth_password_5" {
  default     = ""
  description = "SNMPv3 User Authentication Password."
  sensitive   = true
  type        = string
}

variable "snmp_privacy_password_1" {
  default     = ""
  description = "SNMPv3 User Privacy Password."
  sensitive   = true
  type        = string
}

variable "snmp_privacy_password_2" {
  default     = ""
  description = "SNMPv3 User Privacy Password."
  sensitive   = true
  type        = string
}

variable "snmp_privacy_password_3" {
  default     = ""
  description = "SNMPv3 User Privacy Password."
  sensitive   = true
  type        = string
}

variable "snmp_privacy_password_4" {
  default     = ""
  description = "SNMPv3 User Privacy Password."
  sensitive   = true
  type        = string
}

variable "snmp_privacy_password_5" {
  default     = ""
  description = "SNMPv3 User Privacy Password."
  sensitive   = true
  type        = string
}

variable "snmp_trap_community_1" {
  default     = ""
  description = "Community for a Trap Destination."
  sensitive   = true
  type        = string
}

variable "snmp_trap_community_2" {
  default     = ""
  description = "Community for a Trap Destination."
  sensitive   = true
  type        = string
}

variable "snmp_trap_community_3" {
  default     = ""
  description = "Community for a Trap Destination."
  sensitive   = true
  type        = string
}

variable "snmp_trap_community_4" {
  default     = ""
  description = "Community for a Trap Destination."
  sensitive   = true
  type        = string
}

variable "snmp_trap_community_5" {
  default     = ""
  description = "Community for a Trap Destination."
  sensitive   = true
  type        = string
}

variable "trap_community_string" {
  default     = ""
  description = "SNMP community group used for sending SNMP trap to other devices. Valid only for SNMPv2c."
  sensitive   = true
  type        = string
}

variable "trap_community_string_1" {
  default     = ""
  description = "The default SNMPv1, SNMPv2c community name or SNMPv3 username to include on any trap messages sent to the SNMP host. The name can be 18 characters long."
  sensitive   = true
  type        = string
}

variable "trap_community_string_2" {
  default     = ""
  description = "The default SNMPv1, SNMPv2c community name or SNMPv3 username to include on any trap messages sent to the SNMP host. The name can be 18 characters long."
  sensitive   = true
  type        = string
}

variable "trap_community_string_3" {
  default     = ""
  description = "The default SNMPv1, SNMPv2c community name or SNMPv3 username to include on any trap messages sent to the SNMP host. The name can be 18 characters long."
  sensitive   = true
  type        = string
}

variable "trap_community_string_4" {
  default     = ""
  description = "The default SNMPv1, SNMPv2c community name or SNMPv3 username to include on any trap messages sent to the SNMP host. The name can be 18 characters long."
  sensitive   = true
  type        = string
}

variable "trap_community_string_5" {
  default     = ""
  description = "The default SNMPv1, SNMPv2c community name or SNMPv3 username to include on any trap messages sent to the SNMP host. The name can be 18 characters long."
  sensitive   = true
  type        = string
}

#__________________________________________________________________
#
# Virtual Media Sensitive Variable
#__________________________________________________________________

variable "vmedia_password_1" {
  default     = ""
  description = "Password for vMedia "
  sensitive   = true
  type        = string
}

variable "vmedia_password_2" {
  default     = ""
  description = "Password for vMedia "
  sensitive   = true
  type        = string
}

variable "vmedia_password_3" {
  default     = ""
  description = "Password for vMedia "
  sensitive   = true
  type        = string
}

variable "vmedia_password_4" {
  default     = ""
  description = "Password for vMedia "
  sensitive   = true
  type        = string
}

variable "vmedia_password_5" {
  default     = ""
  description = "Password for vMedia "
  sensitive   = true
  type        = string
}
