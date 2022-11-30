#__________________________________________________________________
#
# Intersight Virtual KVM Policy
# GUI Location: Policies > Create Policy > Virtual KVM
#__________________________________________________________________

resource "intersight_kvm_policy" "virtual_kvm" {
  for_each    = { for v in lookup(local.policies, "virtual_kvm", []) : v.name => v }
  description = lookup(each.value, "description", "${each.value.name} Virtual KVM Policy.")
  enable_local_server_video = lookup(
    each.value, "enable_local_server_video", local.defaults.intersight.policies.virtual_kvm.enable_local_server_video
  )
  enable_video_encryption = lookup(
    each.value, "enable_video_encryption", local.defaults.intersight.policies.virtual_kvm.enable_video_encryption
  )
  enabled = lookup(
    each.value, "enable_virtual_kvm", local.defaults.intersight.policies.virtual_kvm.enable_virtual_kvm
  )
  maximum_sessions = lookup(
    each.value, "maximum_sessions", local.defaults.intersight.policies.virtual_kvm.maximum_sessions
  )
  name        = "${each.key}${local.defaults.intersight.policies.virtual_kvm.name_suffix}"
  remote_port = lookup(each.value, "remote_port", local.defaults.intersight.policies.virtual_kvm.remote_port)
  tunneled_kvm_enabled = lookup(
    each.value, "allow_tunneled_vkvm", local.defaults.intersight.policies.virtual_kvm.allow_tunneled_vkvm
  )
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
