#__________________________________________________________________
#
# Model Data and policy from domains and pools
#__________________________________________________________________

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

variable "certificate_management" {
  default = {
    certificate = {}
    private_key = {}
  }
  description = <<EOT
    Note: Sensitive Variables cannot be added to a for_each loop so these are added seperately.
    * certificate: The IMC or Root CA (KMIP) Certificate in PEM Format.
    * private_key: The IMC Private Key in PEM Format.
  EOT
  sensitive   = true
  type = object({
    certificate = map(string)
    private_key = map(string)
  })
}

#__________________________________________________________________
#
# Drive Security Sensitive Variables
#__________________________________________________________________

variable "drive_security" {
  default = {
    password                          = {}
    server_public_root_ca_certificate = {}
  }
  description = <<EOT
    * password: Drive Security User Password(s).
    * server_public_root_ca_certificate: The root certificate from the KMIP server.
  EOT
  sensitive   = true
  type = object({
    password                          = map(string)
    server_public_root_ca_certificate = map(string)
  })
}

#__________________________________________________________________
#
# Firmware Sensitive Variables
#__________________________________________________________________

variable "firmware" {
  default = {
    cco_password = {}
    cco_user     = {}
  }
  description = <<EOT
    Note: Sensitive Variables cannot be added to a for_each loop so these are added seperately.
    * cco_password: The User Password with Permissions to download the Software from cisco.com.
    * cco_user: The User with Permissions to download the Software from cisco.com.
  EOT
  sensitive   = true
  type = object({
    cco_password = map(string)
    cco_user     = map(string)
  })
}

variable "model" {
  default     = "UCSX-210C-M7"
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


variable "ipmi_over_lan" {
  default     = { encryption_key = {} }
  description = <<-EOT
    Note: Sensitive Variables cannot be added to a for_each loop so these are added seperately.
    Encryption Key to use for IPMI Communication.
    It should have an even number of hexadecimal characters and not exceed 40 characters.
  EOT
  sensitive   = true
  type        = object({ encryption_key = map(string) })
}

#__________________________________________________________________
#
# iSCSI Boot Sensitive Variable
#__________________________________________________________________

variable "iscsi_boot" {
  default     = { password = {} }
  description = "Map of iSCSI Boot Password(s) if utilizing Authentication to the Storage Array."
  sensitive   = true
  type        = object({ password = map(string) })
}

#__________________________________________________________________
#
# LDAP Sensitive Variable
#__________________________________________________________________

variable "ldap" {
  default     = { password = {} }
  description = <<-EOT
    Note: Sensitive Variables cannot be added to a for_each loop so these are added seperately.
    Map of Binding Parameters Password(s)
    It can be any string that adheres to the following constraints. It can have character except spaces, tabs, line breaks. It cannot be more than 254 characters.
  EOT
  sensitive   = true
  type        = object({ password = map(string) })
}

#__________________________________________________________________
#
# Local User Sensitive Variables
#__________________________________________________________________

variable "local_user" {
  default     = { password = {} }
  description = "Map of Local User Password(s).  Note: Sensitive Variables cannot be added to a for_each loop so these are added seperately."
  sensitive   = true
  type        = object({ password = map(string) })
}

#__________________________________________________________________
#
# Persistent Memory Sensitive Variable
#__________________________________________________________________

variable "persistent_memory" {
  default     = { passphrase = {} }
  description = <<EOT
    Note: Sensitive Variables cannot be added to a for_each loop so these are added seperately.
    Secure passphrase to be applied on the Persistent Memory Modules on the server. The allowed characters are:
    * `a-z`, `A-Z`, `0-9` and special characters: `\u0021`,` &`, `#`, `$`, `%`, `+`, `^`, `@`, `_`, `*`, `-`.
  EOT
  sensitive   = true
  type        = object({ passphrase = map(string) })
}

#__________________________________________________________________
#
# SNMP Sensitive Variables
#__________________________________________________________________

variable "snmp" {
  default = {
    access_community_string = {}
    auth_password           = {}
    privacy_password        = {}
    trap_community_string   = {}
  }
  description = <<EOT
    Note: Sensitive Variables cannot be added to a for_each loop so these are added seperately.
    * access_community_string: The default SNMPv1, SNMPv2c community name or SNMPv3 username to include on any trap messages sent to the SNMP host. The name can be 18 characters long.
    * auth_password: Authorization password for the user.
    * privacy_password: Privacy password for the user.
    * trap_community_string: SNMP community group used for sending SNMP trap to other devices. Valid only for SNMPv2c users.
  EOT
  sensitive   = true
  type = object({
    access_community_string = map(string)
    auth_password           = map(string)
    privacy_password        = map(string)
    trap_community_string   = map(string)
  })
}


#__________________________________________________________________
#
# Virtual Media Sensitive Variable
#__________________________________________________________________

variable "virtual_media" {
  default     = { password = {} }
  description = <<-EOT
    Note: Sensitive Variables cannot be added to a for_each loop so these are added seperately.
    Map of vMedia Passwords when Needed for Server Authentication.
  EOT
  sensitive   = true
  type        = object({ password = map(string) })
}
