#__________________________________________________________________
#
# Intersight Syslog Policy
# GUI Location: Policies > Create Policy > Syslog
#__________________________________________________________________

resource "intersight_syslog_policy" "syslog" {
  for_each    = local.syslog
  description = lookup(each.value, "description", "${each.value.name} Syslog Policy.")
  name        = each.value.name
  local_clients {
    min_severity = each.value.local_min_severity
    object_type  = "syslog.LocalFileLoggingClient"
  }
  organization {
    moid        = local.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  dynamic "profiles" {
    for_each = { for v in each.value.profiles : v.name => v }
    content {
      moid        = var.domains[var.organization].switch_profiles[profiles.value.name].moid
      object_type = profiles.value.object_type
    }
  }
  dynamic "remote_clients" {
    for_each = { for k, v in each.value.remote_logging : k => v }
    content {
      enabled      = lookup(remote_clients.value, "enable", local.lsyslog.remote_logging.enable)
      hostname     = remote_clients.value.hostname
      min_severity = lookup(remote_clients.value, "minimum_severity", "warning")
      object_type  = "syslog.RemoteLoggingClient"
      port         = lookup(remote_clients.value, "port", 514)
      protocol     = lookup(remote_clients.value, "protocol", "udp")
    }
  }
  dynamic "tags" {
    for_each = each.value.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
