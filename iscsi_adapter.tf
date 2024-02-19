#__________________________________________________________________
#
# Intersight iSCSI Adapter Policy
# GUI Location: Policies > Create Policy > iSCSI Adapter
#__________________________________________________________________

resource "intersight_vnic_iscsi_adapter_policy" "map" {
  for_each             = local.iscsi_adapter
  connection_time_out  = each.value.tcp_connection_timeout
  description          = coalesce(each.value.description, "${each.value.name} iSCSI Adapter Policy.")
  dhcp_timeout         = each.value.dhcp_timeout
  lun_busy_retry_count = each.value.lun_busy_retry_count
  name                 = each.value.name
  organization { moid = var.orgs[each.value.organization] }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
