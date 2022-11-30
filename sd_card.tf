#__________________________________________________________________
#
# Intersight SD Card Policy
# GUI Location: Policies > Create Policy > SD Card
#__________________________________________________________________

resource "intersight_sdcard_policy" "sd_card" {
  for_each    = { for v in lookup(local.policies, "sd_card", []) : v.name => v }
  description = lookup(each.value, "description", "${each.value.name} SD Card Policy.")
  name        = "${each.key}${local.lsdcard.name_suffix}"
  organization {
    moid        = local.orgs[lookup(each.value, "organization", var.organization)]
    object_type = "organization.Organization"
  }
  dynamic "partitions" {
    for_each = { for v in [lookup(each.value, "enable_os", local.lsdcard.enable_os)
    ] : v => v if lookup(each.value, "enable_os", local.lsdcard.enable_os) == true }
    content {
      type        = "OS"
      object_type = "sdcard.Partition"
      virtual_drives {
        additional_properties = jsonencode({ Name = "Hypervisor" })
        enable                = lookup(each.value, "enable_os", local.lsdcard.enable_os)
        object_type           = "sdcard.OperatingSystem"
      }
    }
  }
  dynamic "partitions" {
    for_each = {
      for v in [lookup(each.value, "enable_diagnostics", local.lsdcard.enable_diagnostics)
        ] : v => v if length(regexall(true, lookup(each.value, "enable_diagnostics", local.lsdcard.enable_diagnostics
        ))) > 0 || length(regexall(true, lookup(each.value, "enable_drivers", local.lsdcard.enable_drivers))
        ) > 0 || length(regexall(true, lookup(each.value, "enable_huu", local.lsdcard.enable_huu))) > 0 || length(
      regexall(true, lookup(each.value, "enable_scu", local.lsdcard.enable_scu))) > 0
    }
    content {
      type        = "Utility"
      object_type = "sdcard.Partition"
      virtual_drives {
        enable      = lookup(each.value, "enable_diagnostics", local.lsdcard.enable_diagnostics)
        object_type = "sdcard.Diagnostics"
      }
      virtual_drives {
        enable      = lookup(each.value, "enable_drivers", local.lsdcard.enable_drivers)
        object_type = "sdcard.Drivers"
      }
      virtual_drives {
        enable      = lookup(each.value, "enable_huu", local.lsdcard.enable_huu)
        object_type = "sdcard.HostUpgradeUtility"
      }
      virtual_drives {
        enable      = lookup(each.value, "enable_scu", local.lsdcard.enable_scu)
        object_type = "sdcard.ServerConfigurationUtility"
      }
    }
  }
  dynamic "tags" {
    for_each = lookup(each.value, "tags", var.tags)
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
