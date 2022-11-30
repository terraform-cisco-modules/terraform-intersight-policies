#__________________________________________________________________
#
# Intersight Virtual Media Policy
# GUI Location: Policies > Create Policy > Virtual Media
#__________________________________________________________________

resource "intersight_vmedia_policy" "virtual_media" {
  for_each      = local.virtual_media
  description   = lookup(each.value, "description", "${each.value.name} Virtual Media Policy.")
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
      authentication_protocol = lookup(mappings.value, "authentication_protocol", "none")
      class_id                = "vmedia.Mapping"
      device_type             = mappings.value.device_type
      file_location           = mappings.value.file_location
      host_name               = ""
      mount_options           = mappings.value.mount_options
      mount_protocol          = mappings.value.protocol
      object_type             = "vmedia.Mapping"
      password = length(
        regexall("1", lookup(mappings.value, "password", 0))) > 0 ? var.vmedia_password_1 : length(
        regexall("2", lookup(mappings.value, "password", 0))) > 0 ? var.vmedia_password_2 : length(
        regexall("3", lookup(mappings.value, "password", 0))) > 0 ? var.vmedia_password_3 : length(
        regexall("4", lookup(mappings.value, "password", 0))) > 0 ? var.vmedia_password_4 : length(
        regexall("5", lookup(mappings.value, "password", 0))
      ) > 0 ? var.vmedia_password_5 : ""
      remote_file = ""
      remote_path = ""
      username    = lookup(mappings.value, "username", "")
      volume_name = mappings.value.name
    }
  }
  dynamic "tags" {
    for_each = each.value.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
