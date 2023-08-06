#__________________________________________________________________
#
# Intersight iSCSI Static Target Policy
# GUI Location: Policies > Create Policy > iSCSI Static Target
#__________________________________________________________________

resource "intersight_vnic_iscsi_static_target_policy" "map" {
  for_each = { for v in lookup(local.policies, "iscsi_static_target", []) : v.name => merge(local.defaults.iscsi_static_target, v, {
    name = "${local.name_prefix.iscsi_static_target}${v.name}${local.name_suffix.iscsi_static_target}"
    tags = lookup(v, "tags", var.tags)
  }) }
  description = coalesce(each.value.description, "${each.value.name} iSCSI Static Target Policy.")
  ip_address  = each.value.ip_address
  name        = each.value.name
  port        = each.value.port
  target_name = each.value.target_name
  organization {
    moid        = local.orgs[var.organization]
    object_type = "organization.Organization"
  }
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
