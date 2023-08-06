#__________________________________________________________________
#
# Intersight IPMI over LAN Policy
# GUI Location: Policies > Create Policy > IPMI over LAN
#__________________________________________________________________

resource "intersight_ipmioverlan_policy" "map" {
  for_each = { for v in lookup(local.policies, "ipmi_over_lan", []) : v.name => merge(local.ipmi, v, {
    name = "${local.name_prefix.ipmi_over_lan}${v.name}${local.name_suffix.ipmi_over_lan}"
    tags = lookup(v, "tags", var.tags)
  }) }
  description = coalesce(each.value.description, "${each.value.name} IPMI over LAN Policy.")
  enabled     = each.value.enabled
  encryption_key = length(var.ipmi_over_lan.encryption_key[each.value.encryption_key]
  ) > 1 ? var.ipmi_over_lan.encryption_key[each.value.encryption_key] : null
  name      = each.value.name
  privilege = each.value.privilege
  organization {
    moid        = local.orgs[var.organization]
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
