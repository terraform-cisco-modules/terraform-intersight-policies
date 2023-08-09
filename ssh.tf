#__________________________________________________________________
#
# Intersight SSH Policy
# GUI Location: Policies > Create Policy > SSH
#__________________________________________________________________

resource "intersight_ssh_policy" "map" {
  for_each = { for v in lookup(local.policies, "ssh", []) : v.name => merge(local.defaults.ssh, v, {
    name = "${local.name_prefix.ssh}${v.name}${local.name_suffix.ssh}"
    tags = lookup(v, "tags", var.policies.global_settings.tags)
  }) }
  description = coalesce(each.value.description, "${each.value.name} SSH Policy.")
  enabled     = each.value.enable_ssh
  name        = each.value.name
  port        = each.value.ssh_port
  timeout     = each.value.ssh_timeout
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
