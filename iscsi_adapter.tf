#__________________________________________________________________
#
# Intersight iSCSI Adapter Policy
# GUI Location: Policies > Create Policy > iSCSI Adapter
#__________________________________________________________________

resource "intersight_vnic_iscsi_adapter_policy" "iscsi_adapter" {
  for_each = { for v in lookup(local.policies, "iscsi_adapter", []) : v.name => v }
  connection_time_out = lookup(
    each.value, "tcp_connection_timeout", local.defaults.iscsi_adapter.tcp_connection_timeout
  )
  description = lookup(
  each.value, "description", "${local.name_prefix.iscsi_adapter}${each.key}${local.name_suffix.iscsi_adapter} iSCSI Adapter Policy.")
  dhcp_timeout = lookup(each.value, "dhcp_timeout", local.defaults.iscsi_adapter.dhcp_timeout)
  lun_busy_retry_count = lookup(
    each.value, "lun_busy_retry_count", local.defaults.iscsi_adapter.lun_busy_retry_count
  )
  name = "${local.name_prefix.iscsi_adapter}${each.key}${local.name_suffix.iscsi_adapter}"
  organization {
    moid        = local.orgs[var.organization]
    object_type = "organization.Organization"
  }
  dynamic "tags" {
    for_each = { for v in lookup(each.value, "tags", var.tags) : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
