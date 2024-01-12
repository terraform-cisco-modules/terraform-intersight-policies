#__________________________________________________________________
#
# Intersight IPMI over LAN Policy
# GUI Location: Policies > Create Policy > IPMI over LAN
#__________________________________________________________________

resource "intersight_ipmioverlan_policy" "map" {
  for_each    = local.ipmi_over_lan
  description = coalesce(each.value.description, "${each.value.name} IPMI over LAN Policy.")
  enabled     = each.value.enabled
  encryption_key = length(local.ps.ipmi_over_lan.encryption_key[each.value.encryption_key]
  ) > 1 ? local.ps.ipmi_over_lan.encryption_key[each.value.encryption_key] : null
  name      = each.value.name
  privilege = each.value.privilege
  organization {
    moid        = var.orgs[each.value.organization]
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
