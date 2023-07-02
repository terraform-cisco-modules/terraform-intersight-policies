#__________________________________________________________________
#
# Intersight IPMI over LAN Policy
# GUI Location: Policies > Create Policy > IPMI over LAN
#__________________________________________________________________

resource "intersight_ipmioverlan_policy" "ipmi_over_lan" {
  for_each = { for v in lookup(local.policies, "ipmi_over_lan", []) : v.name => v }
  description = lookup(
  each.value, "description", "${local.name_prefix.ipmi_over_lan}${each.key}${local.name_suffix.ipmi_over_lan} IPMI over LAN Policy.")
  enabled        = lookup(each.value, "enabled", local.defaults.ipmi_over_lan.enabled)
  encryption_key = lookup(each.value, "ipmi_key", "") == 1 ? var.ipmi_key_1 : null
  name           = "${local.name_prefix.ipmi_over_lan}${each.key}${local.name_suffix.ipmi_over_lan}"
  privilege      = lookup(each.value, "privilege", local.defaults.ipmi_over_lan.privilege)
  organization {
    moid        = local.orgs[var.organization]
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
