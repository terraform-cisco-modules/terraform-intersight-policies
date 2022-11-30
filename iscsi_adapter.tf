#__________________________________________________________________
#
# Intersight iSCSI Adapter Policy
# GUI Location: Policies > Create Policy > iSCSI Adapter
#__________________________________________________________________

resource "intersight_vnic_iscsi_adapter_policy" "iscsi_adapter" {
  for_each = { for v in lookup(local.policies, "iscsi_adapter", []) : v.name => v }
  connection_time_out = lookup(
    each.value, "tcp_connection_timeout", local.defaults.intersight.policies.iscsi_adapter.tcp_connection_timeout
  )
  description  = lookup(each.value, "description", "${each.value.name} iSCSI Adapter Policy.")
  dhcp_timeout = lookup(each.value, "dhcp_timeout", local.defaults.intersight.policies.iscsi_adapter.dhcp_timeout)
  lun_busy_retry_count = lookup(
    each.value, "lun_busy_retry_count", local.defaults.intersight.policies.iscsi_adapter.lun_busy_retry_count
  )
  name = "${each.key}${local.defaults.intersight.policies.iscsi_adapter.name_suffix}"
  organization {
    moid        = local.orgs[lookup(each.value, "organization", var.organization)]
    object_type = "organization.Organization"
  }
  dynamic "tags" {
    for_each = lookup(each.value, "tags", var.tags)
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
