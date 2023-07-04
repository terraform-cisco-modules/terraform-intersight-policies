#__________________________________________________________________
#
# Intersight Drive Security Policy
# GUI Location: Policies > Create Policy > Drive Security
#__________________________________________________________________

resource "intersight_storage_drive_security_policy" "drive_security" {
  for_each = { for v in local.drive_security : v.name => v }
  description = lookup(
  each.value, "description", "${each.value.name} Drive Security Policy.")
  key_setting {
    object_type = ""
    remote_key {
      auth_credentials {
        password = length(compact([each.value.username])
        ) > 0 ? var.drive_security_password : ""
        use_authentication = length(compact([each.value.username])) > 0 ? true : false
        username           = each.value.username
      }
      primary_server {
        ip_address = each.value.primary_server.ip_address_hostname
        port       = each.value.primary_server.port
        timeout    = each.value.primary_server.timeout
      }
      secondary_server {
        ip_address = each.value.secondary_server.ip_address_hostname
        port       = each.value.secondary_server.port
        timeout    = each.value.secondary_server.timeout
      }
      server_certificate = base64encode(var.drive_security_server_ca_certificate)
    }
  }
  name = each.value.name
  organization {
    moid        = local.orgs[var.organization]
    object_type = "organization.Organization"
  }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
