#__________________________________________________________________
#
# Intersight Drive Security Policy
# GUI Location: Policies > Create Policy > Drive Security
#__________________________________________________________________
resource "intersight_storage_drive_security_policy" "map" {
  for_each    = local.drive_security
  description = coalesce(each.value.description, "${each.value.name} Drive Security Policy.")
  key_setting {
    object_type = ""
    remote_key {
      auth_credentials {
        password = length(compact([each.value.remote_key_management.enable_authentication.username])
        ) > 0 ? local.ps.drive_security.password[each.value.remote_key_management.enable_authentication.password] : ""
        use_authentication = length(compact([each.value.remote_key_management.enable_authentication.username])) > 0 ? true : false
        username           = each.value.remote_key_management.enable_authentication.username
      }
      primary_server {
        ip_address = each.value.remote_key_management.primary_server.hostname_ip_address
        port       = each.value.remote_key_management.primary_server.port
        timeout    = each.value.remote_key_management.primary_server.timeout
      }
      secondary_server {
        ip_address = each.value.remote_key_management.secondary_server.hostname_ip_address
        port       = each.value.remote_key_management.secondary_server.port
        timeout    = each.value.remote_key_management.secondary_server.timeout
      }
      server_certificate = base64encode(
        local.ps.drive_security.server_public_root_ca_certificate[each.value.remote_key_management.server_public_root_ca_certificate]
      )
    }
  }
  name = each.value.name
  organization { moid = var.orgs[each.value.org] }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}