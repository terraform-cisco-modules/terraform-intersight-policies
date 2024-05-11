#__________________________________________________________________
#
# Intersight Virtual KVM Policy
# GUI Location: Policies > Create Policy > Virtual KVM
#__________________________________________________________________
resource "intersight_kvm_policy" "map" {
  for_each                  = local.virtual_kvm
  description               = coalesce(each.value.description, "${each.value.name} Virtual KVM Policy.")
  enable_local_server_video = each.value.enable_local_server_video
  enable_video_encryption   = each.value.enable_video_encryption
  enabled                   = each.value.enable_virtual_kvm
  maximum_sessions          = each.value.maximum_sessions
  name                      = each.value.name
  remote_port               = each.value.remote_port
  tunneled_kvm_enabled      = each.value.allow_tunneled_vkvm
  organization { moid = var.orgs[each.value.organization] }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
