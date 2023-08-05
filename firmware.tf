#__________________________________________________________________
#
# Intersight Firmware Policy
# GUI Location: Policies > Create Policy > Firmware
#__________________________________________________________________

data "intersight_iam_account" "account" {
}

#resource "intersight_firmware_eula" "eula" {
#  account {
#    object_type = "iam.Account"
#    moid        = data.intersight_iam_account.account.results[0].moid
#  }
#}

resource "intersight_softwarerepository_authorization" "auth" {
  for_each        = { for v in ["cco_auth"] : v => v if length(lookup(local.policies, "firmware", {})) > 0 }
  password        = var.cco_password
  repository_type = "Cisco"
  user_id         = var.cco_user
  account {
    object_type = "iam.Account"
    moid        = data.intersight_iam_account.account.results[0].moid
  }
}

resource "intersight_firmware_policy" "fw" {
  for_each    = local.firmware
  description = lookup(each.value, "description", "${each.value.name} Firmware Policy.")
  exclude_component_list = anytrue(
    [
      each.value.advanced_mode.exclude_drives,
      each.value.advanced_mode.exclude_drives_except_boot_drives,
      each.value.advanced_mode.exclude_storage_controllers,
      each.value.advanced_mode.exclude_storage_sas_expander,
      each.value.advanced_mode.exclude_storage_u2
    ]
    ) ? compact(concat([
      length(regexall(true, each.value.advanced_mode.exclude_drives)) > 0 ? "local-disk" : ""], [
      length(regexall(true, each.value.advanced_mode.exclude_drives_except_boot_drives)) > 0 ? "local-disk" : ""], [
      length(regexall(true, each.value.advanced_mode.exclude_storage_controllers)) > 0 ? "storage-controller" : ""], [
      length(regexall(true, each.value.advanced_mode.exclude_storage_sas_expander)) > 0 ? "storage-sasexpander" : ""], [
      length(regexall(true, each.value.advanced_mode.exclude_storage_u2)) > 0 ? "storage-u2" : ""
  ])) : ["none"]
  name            = "${local.name_prefix.firmware}${each.key}${local.name_suffix.firmware}"
  target_platform = lookup(each.value, "target_platform", local.fw.target_platform)
  organization {
    moid        = local.orgs[var.organization]
    object_type = "organization.Organization"
  }
  dynamic "model_bundle_combo" {
    for_each = lookup(each.value, "models", [])
    content {
      bundle_version = lookup(model_bundle_combo.value, "firmware_version", local.fw.models.firmware_version)
      model_family   = lookup(model_bundle_combo.value, "server_model", local.fw.models.server_model)
      object_type    = "firmware.ModelBundleVersion"
    }
  }
  dynamic "tags" {
    for_each = { for v in lookup(each.value, "tags", var.tags) : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}