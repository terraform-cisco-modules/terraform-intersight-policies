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
  organization {
    moid        = local.orgs[local.organization]
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

resource "intersight_vnic_iscsi_adapter_policy" "data" {
  depends_on = [intersight_vnic_iscsi_adapter_policy.map]
  for_each = {
    for v in local.pp.iscsi_adapter : v => v if lookup(local.iscsi_adapter, element(split(":", v), 1), "#NOEXIST") == "#NOEXIST"
  }
  name = element(split(":", each.value), 1)
  organization {
    moid = local.orgs[element(split(":", each.value), 0)]
  }
  lifecycle {
    ignore_changes = [
      account_moid, additional_properties, ancestors, create_time, description, domain_group_moid, mod_time, owners,
      parent, permission_resources, shared_scope, tags, version_context
    ]
    prevent_destroy = true
  }
}
