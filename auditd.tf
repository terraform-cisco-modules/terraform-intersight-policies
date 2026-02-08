#__________________________________________________________________
#
# Intersight VLAN Policy
# GUI Location: Policies > Create Policy > VLAN
#__________________________________________________________________
resource "intersight_auditd_policy" "map" {
  for_each        = local.auditd
  admin_state      = each.value.enabled == true ? "Enabled" : "Disabled"
  audit_log_level  = each.value.minimum_severity_to_report
  description     = coalesce(each.value.description, "${each.value.name} Auditd Policy.")
  name            = each.value.name
  organization { moid = var.orgs[each.value.org] }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

