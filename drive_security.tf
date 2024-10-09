#__________________________________________________________________
#
# Intersight Drive Security Policy
# GUI Location: Policies > Create Policy > Drive Security
#__________________________________________________________________
resource "intersight_storage_drive_security_policy" "map" {
  for_each    = local.drive_security
  description = coalesce(each.value.description, "${each.value.name} Drive Security Policy.")
  key_setting {
    key_type = each.value.manual_key.new_security_key_passphrase != 0 ? "Manual" : "Kmip"
    dynamic "manual_key" {
      for_each = { for k, v in { manual_key = each.value.manual_key } : k => v if v.new_security_key_passphrase != 0 }
      content {
        existing_key = length(regexall("0", tostring(manual_key.value.current_security_key_passphrase))
        ) == 0 ? local.ps.drive_security.current_security_key_passphrase[manual_key.value.current_security_key_passphrase] : ""
        new_key = length(regexall("0", tostring(manual_key.value.new_security_key_passphrase))
        ) == 0 ? local.ps.drive_security.new_security_key_passphrase[manual_key.value.new_security_key_passphrase] : ""
      }
    }
    object_type = "storage.KeySetting"
    dynamic "remote_key" {
      for_each = { for k, v in { remote_key = each.value.remote_key_management } : k => v if v.assigned_sensitive_data == true }
      content {
        auth_credentials {
          password = length(compact([remote_key.value.enable_authentication.username])
          ) > 0 ? local.ps.drive_security.password[remote_key.value.enable_authentication.password] : ""
          use_authentication = length(compact([remote_key.value.enable_authentication.username])) > 0 ? true : false
          username           = remote_key.value.enable_authentication.username
        }
        existing_key = length(regexall("0", tostring(remote_key.value.current_security_key_passphrase))
        ) == 0 ? local.ps.drive_security.current_security_key_passphrase[remote_key.value.current_security_key_passphrase] : ""
        primary_server {
          enable_drive_security = length(compact([remote_key.value.primary_server.hostname_ip_address])) > 0 ? true : false
          ip_address            = remote_key.value.primary_server.hostname_ip_address
          port                  = remote_key.value.primary_server.port
          timeout               = remote_key.value.primary_server.timeout
        }
        secondary_server {
          enable_drive_security = length(compact([remote_key.value.secondary_server.hostname_ip_address])) > 0 ? true : false
          ip_address            = remote_key.value.secondary_server.hostname_ip_address
          port                  = remote_key.value.secondary_server.port
          timeout               = remote_key.value.secondary_server.timeout
        }
        server_certificate = base64encode(
          local.ps.drive_security.server_public_root_ca_certificate[remote_key.value.server_public_root_ca_certificate]
        )

      }
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
