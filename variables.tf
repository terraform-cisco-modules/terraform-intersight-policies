#__________________________________________________________________
#
# Model Data and policy from domains and pools
#__________________________________________________________________

variable "model" {
  description = "Model data."
  type        = any
}

variable "domains" {
  description = "Domain Moids."
  type        = any
}

variable "organization" {
  default     = "default"
  description = "Name of the default intersight Organization."
  type        = string
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

variable "base64_certificate_1" {
  default     = ""
  description = "The Server Certificate in Base64 format."
  sensitive   = true
  type        = string
}

variable "base64_certificate_2" {
  default     = ""
  description = "The Server Certificate in Base64 format."
  sensitive   = true
  type        = string
}

variable "base64_certificate_3" {
  default     = ""
  description = "The Server Certificate in Base64 format."
  sensitive   = true
  type        = string
}

variable "base64_certificate_4" {
  default     = ""
  description = "The Server Certificate in Base64 format."
  sensitive   = true
  type        = string
}

variable "base64_certificate_5" {
  default     = ""
  description = "The Server Certificate in Base64 format."
  sensitive   = true
  type        = string
}

variable "base64_private_key_1" {
  default     = ""
  description = "Private Key in Base64 Format."
  sensitive   = true
  type        = string
}

variable "base64_private_key_2" {
  default     = ""
  description = "Private Key in Base64 Format."
  sensitive   = true
  type        = string
}

variable "base64_private_key_3" {
  default     = ""
  description = "Private Key in Base64 Format."
  sensitive   = true
  type        = string
}

variable "base64_private_key_4" {
  default     = ""
  description = "Private Key in Base64 Format."
  sensitive   = true
  type        = string
}

variable "base64_private_key_5" {
  default     = ""
  description = "Private Key in Base64 Format."
  sensitive   = true
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
