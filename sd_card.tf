#__________________________________________________________________
#
# Intersight SD Card Policy
# GUI Location: Policies > Create Policy > SD Card
#__________________________________________________________________

resource "intersight_sdcard_policy" "map" {
  for_each    = local.sd_card
  description = coalesce(each.value.description, "${each.value.name} SD Card Policy.")
  name        = each.value.name
  organization {
    moid        = var.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  dynamic "partitions" {
    for_each = { for v in [each.value.enable_os] : v => v if each.value.enable_os == true }
    content {
      type        = "OS"
      object_type = "sdcard.Partition"
      virtual_drives {
        additional_properties = jsonencode({ Name = "Hypervisor" })
        enable                = each.value.enable_os
        object_type           = "sdcard.OperatingSystem"
      }
    }
  }
  dynamic "partitions" {
    for_each = {
      for v in [each.value.enable_diagnostics] : v => v if length(regexall(true, each.value.enable_diagnostics)
        ) > 0 || length(regexall(true, each.value.enable_drivers)) > 0 || length(regexall(true, each.value.enable_huu)
      ) > 0 || length(regexall(true, each.value.enable_scu)) > 0
    }
    content {
      type        = "Utility"
      object_type = "sdcard.Partition"
      virtual_drives {
        enable      = each.value.enable_diagnostics
        object_type = "sdcard.Diagnostics"
      }
      virtual_drives {
        enable      = each.value.enable_drivers
        object_type = "sdcard.Drivers"
      }
      virtual_drives {
        enable      = each.value.enable_huu
        object_type = "sdcard.HostUpgradeUtility"
      }
      virtual_drives {
        enable      = each.value.enable_scu
        object_type = "sdcard.ServerConfigurationUtility"
      }
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
