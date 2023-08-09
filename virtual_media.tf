#__________________________________________________________________
#
# Intersight Virtual Media Policy
# GUI Location: Policies > Create Policy > Virtual Media
#__________________________________________________________________

resource "intersight_vmedia_policy" "map" {
  for_each = {
    for v in lookup(local.policies, "virtual_media", []) : v.name => merge(local.vmedia, v, {
      add_virtual_media = [for e in lookup(v, "add_virtual_media", {}) : merge(local.vmedia.add_virtual_media, e)]
      name              = "${local.npfx.virtual_media}${v.name}${local.nsfx.virtual_media}"
      organization      = local.organization
      tags              = lookup(v, "tags", var.policies.global_settings.tags)
    })
  }
  description   = coalesce(each.value.description, "${each.value.name} Virtual Media Policy.")
  enabled       = each.value.enable_virtual_media
  encryption    = each.value.enable_virtual_media_encryption
  low_power_usb = each.value.enable_low_power_usb
  name          = each.value.name
  organization {
    moid        = local.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  dynamic "mappings" {
    for_each = { for v in each.value.add_virtual_media : v.name => v }
    content {
      additional_properties   = ""
      authentication_protocol = mappings.value.authentication_protocol
      class_id                = "vmedia.Mapping"
      device_type             = mappings.value.device_type
      file_location           = mappings.value.file_location
      host_name               = ""
      mount_options           = mappings.value.mount_options
      mount_protocol          = mappings.value.protocol
      object_type             = "vmedia.Mapping"
      password = length(compact([mappings.value.username])
      ) > 0 ? local.ps.virtual_media.password[mappings.value.password] : ""
      remote_file = ""
      remote_path = ""
      username    = mappings.value.username
      volume_name = mappings.value.name
    }
  }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
