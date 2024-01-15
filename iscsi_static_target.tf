#__________________________________________________________________
#
# Intersight iSCSI Static Target Policy
# GUI Location: Policies > Create Policy > iSCSI Static Target
#__________________________________________________________________

resource "intersight_vnic_iscsi_static_target_policy" "map" {
  for_each    = local.iscsi_static_target
  description = coalesce(each.value.description, "${each.value.name} iSCSI Static Target Policy.")
  ip_address  = each.value.ip_address
  name        = each.value.name
  port        = each.value.port
  target_name = each.value.target_name
  organization { moid = var.orgs[each.value.organization] }
  dynamic "lun" {
    for_each = { for v in [lookup(each.value, "lun_id", 0)] : v => v }
    content {
      additional_properties = ""
      bootable              = true
      lun_id                = lun.key
      object_type           = "vnic.Lun"
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

resource "intersight_vnic_iscsi_static_target_policy" "data" {
  depends_on = [intersight_vnic_iscsi_static_target_policy.map]
  for_each   = { for v in local.pp.iscsi_static_target : v => v if lookup(local.iscsi_static_target, v, "#NOEXIST") == "#NOEXIST" }
  name       = element(split("/", each.value), 1)
  organization { moid = var.orgs[element(split("/", each.value), 0)] }
  lifecycle {
    ignore_changes = [
      account_moid, additional_properties, ancestors, create_time, description, domain_group_moid, mod_time, owners,
      permission_resources, shared_scope, tags, version_context
    ]
    prevent_destroy = true
  }
}
