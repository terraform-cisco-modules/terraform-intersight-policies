#__________________________________________________________________
#
# Intersight IPMI over LAN Policy
# GUI Location: Policies > Create Policy > IPMI over LAN
#__________________________________________________________________

resource "intersight_ipmioverlan_policy" "ipmi_over_lan" {
  for_each       = { for v in lookup(local.policies, "ipmi_over_lan", []) : v.name => v }
  description    = lookup(each.value, "description", "${each.value.name} IPMI over LAN Policy.")
  enabled        = lookup(each.value, "enabled", local.defaults.intersight.policies.ipmi_over_lan.enabled)
  encryption_key = lookup(each.value, "ipmi_key", "") == 1 ? var.ipmi_key_1 : null
  name           = "${each.key}${local.defaults.intersight.policies.ipmi_over_lan.name_suffix}"
  privilege      = lookup(each.value, "privilege", local.defaults.intersight.policies.ipmi_over_lan.privilege)
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
