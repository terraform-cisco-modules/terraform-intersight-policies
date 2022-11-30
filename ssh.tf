#__________________________________________________________________
#
# Intersight SSH Policy
# GUI Location: Policies > Create Policy > SSH
#__________________________________________________________________

resource "intersight_ssh_policy" "ssh" {
  for_each    = { for v in lookup(local.policies, "ssh", []) : v.name => v }
  description = lookup(each.value, "description", "${each.value.name} SSH Policy.")
  enabled     = lookup(each.value, "enable_ssh", local.defaults.intersight.policies.ssh.enable_ssh)
  name        = "${each.key}${local.defaults.intersight.policies.ssh.name_suffix}"
  port        = lookup(each.value, "ssh_port", local.defaults.intersight.policies.ssh.ssh_port)
  timeout     = lookup(each.value, "ssh_timeout", local.defaults.intersight.policies.ssh.ssh_timeout)
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
