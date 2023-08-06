#__________________________________________________________________
#
# Intersight Virtual KVM Policy
# GUI Location: Policies > Create Policy > Virtual KVM
#__________________________________________________________________

resource "intersight_kvm_policy" "map" {
  for_each = { for v in lookup(local.policies, "virtual_kvm", []) : v.name => merge(local.defaults.virtual_kvm, v, {
    name = "${local.name_prefix.virtual_kvm}${v.name}${local.name_suffix.virtual_kvm}"
    tags = lookup(v, "tags", var.tags)
  }) }
  description               = coalesce(each.value.description, "${each.value.name} Virtual KVM Policy.")
  enable_local_server_video = each.value.enable_local_server_video
  enable_video_encryption   = each.value.enable_video_encryption
  enabled                   = each.value.enable_virtual_kvm
  maximum_sessions          = each.value.maximum_sessions
  name                      = each.value.name
  remote_port               = each.value.remote_port
  tunneled_kvm_enabled      = each.value.allow_tunneled_vkvm
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
