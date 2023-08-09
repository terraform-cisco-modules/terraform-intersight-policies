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

resource "intersight_softwarerepository_authorization" "map" {
  for_each = { for v in [lookup(local.policies, "firmware_authenticate", {})] : "cco_auth" => merge(local.fw, v
  ) if length(lookup(local.policies, "firmware_authenticate", {})) > 0 }
  password        = local.ps.firmware.cco_password[each.value.cco_password]
  repository_type = "Cisco"
  user_id         = local.ps.firmware.cco_user[each.value.cco_user]
  account {
    object_type = "iam.Account"
    moid        = data.intersight_iam_account.account.results[0].moid
  }
}

resource "intersight_firmware_policy" "map" {
  for_each = {
    for v in lookup(local.policies, "firmware", []) : v.name => merge(local.fw, v, {
      advanced_mode = merge(local.fw.advanced_mode, lookup(v, "advanced_mode", {}))
      name          = "${local.name_prefix.firmware}${v.name}${local.name_suffix.firmware}"
      model_bundle_versions = { for i in flatten([
        for e in lookup(v, "model_bundle_version", []) : [
          for m in e.server_models : {
            model   = m
            version = e.firmware_version
          }
        ]
      ]) : "${i.version}:${i.model}" => i }
      organization = local.organization
      tags         = lookup(v, "tags", var.policies.global_settings.tags)
    })
  }
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
      length(regexall(true, e.exclude_drives_except_boot_drives)) > 0 ? "local-disk" : ""], [
      length(regexall(true, e.exclude_storage_controllers)) > 0 ? "storage-controller" : ""], [
      length(regexall(true, e.exclude_storage_sas_expander)) > 0 ? "storage-sasexpander" : ""], [
      length(regexall(true, e.exclude_storage_u2)) > 0 ? "storage-u2" : ""
  ])) : ["none"]][0]
  name            = each.value.name
  target_platform = lookup(each.value, "target_platform", local.fw.target_platform)
  organization {
    moid        = local.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
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