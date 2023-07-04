#__________________________________________________________________
#
# Intersight NTP Policy
# GUI Location: Policies > Create Policy > NTP
#__________________________________________________________________

resource "intersight_ntp_policy" "ntp" {
  for_each    = local.ntp
  description = lookup(each.value, "description", "${each.value.name} NTP Policy.")
  enabled     = each.value.enabled
  name        = each.value.name
  ntp_servers = each.value.ntp_servers
  timezone    = each.value.timezone
  organization {
    moid        = local.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  dynamic "authenticated_ntp_servers" {
    for_each = lookup(each.value, "authenticated_ntp_servers", [])
    content {
      key_type      = "SHA1"
      object_type   = authenticated_ntp_servers.value.object_type
      server_name   = authenticated_ntp_servers.value.server_name
      sym_key_id    = authenticated_ntp_servers.value.sym_key_id
      sym_key_value = authenticated_ntp_servers.value.sym_key_value
    }
  }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
