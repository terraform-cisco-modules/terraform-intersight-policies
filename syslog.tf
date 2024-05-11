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
    min_severity = each.value.local_logging.minimum_severity
    object_type  = "syslog.LocalFileLoggingClient"
  }
  organization { moid = var.orgs[each.value.organization] }
  dynamic "remote_clients" {
    for_each = { for k, v in each.value.remote_logging : k => merge(local.defaults.syslog.remote_logging, v) }
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
