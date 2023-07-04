#__________________________________________________________________
#
# Intersight SD Card Policy
# GUI Location: Policies > Create Policy > SD Card
#__________________________________________________________________

resource "intersight_sdcard_policy" "sd_card" {
  for_each = { for v in lookup(local.policies, "sd_card", []) : v.name => v }
  description = lookup(
  each.value, "description", "${local.name_prefix.sd_card}${each.key}${local.name_suffix.sd_card} SD Card Policy.")
  name = "${local.name_prefix.sd_card}${each.key}${local.name_suffix.sd_card}"
  organization {
    moid        = local.orgs[var.organization]
    object_type = "organization.Organization"
  }
  dynamic "partitions" {
    for_each = { for v in [lookup(each.value, "enable_os", local.defaults.sd_card.enable_os)
    ] : v => v if lookup(each.value, "enable_os", local.defaults.sd_card.enable_os) == true }
    content {
      type        = "OS"
      object_type = "sdcard.Partition"
      virtual_drives {
        additional_properties = jsonencode({ Name = "Hypervisor" })
        enable                = lookup(each.value, "enable_os", local.defaults.sd_card.enable_os)
        object_type           = "sdcard.OperatingSystem"
      }
    }
  }
  dynamic "partitions" {
    for_each = {
      for v in [lookup(each.value, "enable_diagnostics", local.defaults.sd_card.enable_diagnostics)
        ] : v => v if length(regexall(true, lookup(
          each.value, "enable_diagnostics", local.defaults.sd_card.enable_diagnostics
        ))) > 0 || length(regexall(true, lookup(each.value, "enable_drivers", local.defaults.sd_card.enable_drivers))
        ) > 0 || length(regexall(true, lookup(each.value, "enable_huu", local.defaults.sd_card.enable_huu))) > 0 || length(
      regexall(true, lookup(each.value, "enable_scu", local.defaults.sd_card.enable_scu))) > 0
    }
    content {
      type        = "Utility"
      object_type = "sdcard.Partition"
      virtual_drives {
        enable      = lookup(each.value, "enable_diagnostics", local.defaults.sd_card.enable_diagnostics)
        object_type = "sdcard.Diagnostics"
      }
      virtual_drives {
        enable      = lookup(each.value, "enable_drivers", local.defaults.sd_card.enable_drivers)
        object_type = "sdcard.Drivers"
      }
      virtual_drives {
        enable      = lookup(each.value, "enable_huu", local.defaults.sd_card.enable_huu)
        object_type = "sdcard.HostUpgradeUtility"
      }
      virtual_drives {
        enable      = lookup(each.value, "enable_scu", local.defaults.sd_card.enable_scu)
        object_type = "sdcard.ServerConfigurationUtility"
      }
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
