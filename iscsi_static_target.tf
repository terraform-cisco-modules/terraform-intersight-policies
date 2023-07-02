#__________________________________________________________________
#
# Intersight iSCSI Static Target Policy
# GUI Location: Policies > Create Policy > iSCSI Static Target
#__________________________________________________________________

resource "intersight_vnic_iscsi_static_target_policy" "iscsi_static_target" {
  for_each = { for v in lookup(local.policies, "iscsi_static_target", []) : v.name => v }
  description = lookup(
  each.value, "description", "${local.name_prefix.iscsi_static_target}${each.key}${local.name_suffix.iscsi_static_target} iSCSI Static Target Policy.")
  ip_address  = each.value.ip_address
  name        = "${local.name_prefix.iscsi_static_target}${each.key}${local.name_suffix.iscsi_static_target}"
  port        = each.value.port
  target_name = each.value.target_name
  organization {
    moid        = local.orgs[var.organization]
    object_type = "organization.Organization"
  }
  dynamic "lun" {
    for_each = lookup(each.value, "luns", [])
    content {
      additional_properties = ""
      bootable = lookup(
        lun.value, "bootable", local.defaults.iscsi_static_target.luns.bootable
      )
      lun_id      = lun.value.lun_id
      object_type = "vnic.Lun"
    }
  }
  dynamic "tags" {
    for_each = lookup(each.value, "tags", var.tags)
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
