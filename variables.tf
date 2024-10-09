/*_____________________________________________________________________________________________________________________

Model Data from Top Level Module
_______________________________________________________________________________________________________________________
*/
variable "global_settings" {
  description = "YAML to HCL Data - global_settings."
  type        = any
}

variable "model" {
  description = "YAML to HCL Data - model."
  type        = any
}

variable "orgs" {
  description = "Intersight Organizations Moid Data."
  type        = any
}

variable "pools" {
  description = "Pools - Module Output."
  type        = any
}


#__________________________________________________________________
#
# Policies Sensitive Variables
#__________________________________________________________________

variable "policies_sensitive" {
  default = {
    certificate_management = {
      certificate = {}
      private_key = {}
    }
    drive_security = {
      current_security_key_passphrase   = {}
      new_security_key_passphrase       = {}
      password                          = {}
      server_public_root_ca_certificate = {}
    }
    firmware = {
      cco_password = {}
      cco_user     = {}
    }
    ipmi_over_lan = {
      encryption_key = {}
    }
    iscsi_boot = {
      password = {}
    }
    ldap = {
      password = {}
    }
    local_user = {
      password = {}
    }
    persistent_memory = {
      passphrase = {}
    }
    snmp = {
      access_community_string = {}
      auth_password           = {}
      privacy_password        = {}
      trap_community_string   = {}
    }
    virtual_media = {
      password = {}
    }
  }
  description = <<-EOT
    Note: Sensitive Variables cannot be added to a for_each loop so these are added seperately.
    certificate_management:
      * certificate: The IMC or Root CA (KMIP) Certificate in PEM Format.
      * private_key: The IMC Private Key in PEM Format.
    drive_security:
      * current_security_key_passphrase: Drive Security -> Manual Key/Remote Key Management -> Current Security Key Passphrase.
      * new_security_key_passphrase: Drive Security -> Manual Key -> New Security Key Passphrase.
      * password: Drive Security -> Remote Key Management -> Enable Authentication: Password.
      * server_public_root_ca_certificate: The root certificate from the KMIP server.
    firmware:
      * cco_password: The User Password with Permissions to download the Software from cisco.com.
      * cco_user: The User with Permissions to download the Software from cisco.com.
    ipmi_over_lan:
      * encrypt_key:  Encryption Key to use for IPMI Communication.
        It should have an even number of hexadecimal characters and not exceed 40 characters.
    iscsi_boot:
      * password: Map of iSCSI Boot Password(s) if utilizing Authentication to the Storage Array.
    ldap:
      * password: Map of Binding Parameters Password(s).  It can be any string that adheres to the following constraints:
        - It can have character except spaces, tabs, line breaks.
        - It cannot be more than 254 characters.
    local_user:
      * password: Map of Local User Password(s).
    persistent_memory:
      * password: Secure passphrase to be applied on the Persistent Memory Modules on the server. The allowed characters are:
        - `a-z`, `A-Z`, `0-9` and special characters: `\u0021`,` &`, `#`, `$`, `%`, `+`, `^`, `@`, `_`, `*`, `-`.
    snmp:
      * access_community_string: The default SNMPv1, SNMPv2c community name or SNMPv3 username to include on any trap messages sent to the SNMP host. The name can be 18 characters long.
      * auth_password: Authorization password for the user.
      * privacy_password: Privacy password for the user.
      * trap_community_string: SNMP community group used for sending SNMP trap to other devices. Valid only for SNMPv2c users.
    virtual_media:
      * password: Map of vMedia Passwords when Needed for Server Authentication.
  EOT
  type = object({
    certificate_management = object({
      certificate = map(string)
      private_key = map(string)
    })
    drive_security = object({
      current_security_key_passphrase   = map(string)
      new_security_key_passphrase       = map(string)
      password                          = map(string)
      server_public_root_ca_certificate = map(string)
    })
    firmware = object({
      cco_password = map(string)
      cco_user     = map(string)
    })
    ipmi_over_lan = object({
      encryption_key = map(string)
    })
    iscsi_boot = object({
      password = map(string)
    })
    ldap = object({
      password = map(string)
    })
    local_user = object({
      password = map(string)
    })
    persistent_memory = object({
      passphrase = map(string)
    })
    snmp = object({
      access_community_string = map(string)
      auth_password           = map(string)
      privacy_password        = map(string)
      trap_community_string   = map(string)
    })
    virtual_media = object({
      password = map(string)
    })
  })
}
