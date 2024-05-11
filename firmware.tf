#__________________________________________________________________
#
# Intersight Firmware Policy
# GUI Location: Policies > Create Policy > Firmware
#__________________________________________________________________
data "intersight_iam_account" "account" {
}

resource "intersight_softwarerepository_authorization" "map" {
  for_each        = { for v in local.firmware_authenticate : "auth" => v }
  password        = local.ps.firmware.cco_password[each.value.cco_password]
  repository_type = "Cisco"
  user_id         = local.ps.firmware.cco_user[each.value.cco_user]
  account {
    object_type = "iam.Account"
    moid        = data.intersight_iam_account.account.results[0].moid
  }
}

resource "intersight_firmware_policy" "map" {
  for_each    = local.firmware
  description = coalesce(each.value.description, "${each.value.name} Firmware Policy.")
  exclude_component_list = [for e in [each.value.advanced_mode] : anytrue(
    [
      e.exclude_drives,
      e.exclude_drives_except_boot_drives,
      e.exclude_storage_controllers,
      e.exclude_storage_sas_expander,
      e.exclude_storage_u2
    ]
    ) ? compact(concat([
      length(regexall(true, e.exclude_drives)) > 0 ? "local-disk" : ""], [
      length(regexall(true, e.exclude_drives_except_boot_drives)) > 0 ? "drives-except-boot-drives" : ""], [
      length(regexall(true, e.exclude_storage_controllers)) > 0 ? "storage-controller" : ""], [
      length(regexall(true, e.exclude_storage_sas_expander)) > 0 ? "storage-sasexpander" : ""], [
      length(regexall(true, e.exclude_storage_u2)) > 0 ? "storage-u2" : ""
  ])) : ["none"]][0]
  name            = each.value.name
  target_platform = lookup(each.value, "target_platform", local.fw.target_platform)
  organization { moid = var.orgs[each.value.organization] }
  dynamic "model_bundle_combo" {
    for_each = each.value.model_bundle_versions
    content {
      bundle_version = model_bundle_combo.value.version
      model_family   = model_bundle_combo.value.model
      object_type    = "firmware.ModelBundleVersion"
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