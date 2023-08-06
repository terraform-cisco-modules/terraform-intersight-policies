#__________________________________________________________________
#
# Intersight Syslog Policy
# GUI Location: Policies > Create Policy > Syslog
#__________________________________________________________________

resource "intersight_syslog_policy" "map" {
  for_each    = local.syslog
  description = coalesce(each.value.description, "${each.value.name} Syslog Policy.")
  name        = each.value.name
  local_clients {
    min_severity = each.value.local_min_severity
    object_type  = "syslog.LocalFileLoggingClient"
  }
  organization {
    moid        = local.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  dynamic "remote_clients" {
    for_each = { for k, v in each.value.remote_logging : k => merge(local.lsyslog.remote_logging, v) }
    content {
      enabled      = remote_clients.value.enable
      hostname     = remote_clients.value.hostname
      min_severity = remote_clients.value.minimum_severity
      object_type  = "syslog.RemoteLoggingClient"
      port         = remote_clients.value.port
      protocol     = remote_clients.value.protocol
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
