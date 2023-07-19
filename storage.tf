#__________________________________________________________________
#
# Intersight Storage Policy
# GUI Location: Policies > Create Policy > Storage
#__________________________________________________________________

resource "intersight_storage_storage_policy" "storage" {
  for_each                 = local.storage
  default_drive_mode       = each.value.default_drive_state
  description              = lookup(each.value, "description", "${each.value.name} Storage Policy.")
  global_hot_spares        = each.value.global_hot_spares
  name                     = each.value.name
  unused_disks_state       = each.value.unused_disks_state
  use_jbod_for_vd_creation = each.value.use_jbod_for_vd_creation
  # retain_policy_virtual_drives = each.value.retain_policy
  organization {
    moid        = local.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  dynamic "m2_virtual_drive" {
    for_each = each.value.m2_raid_configuration
    content {
      controller_slot = m2_virtual_drive.value.slot
      enable          = true
      # additional_properties = ""
      # object_type           = "storage.DiskGroupPolicy"
    }
  }
  dynamic "raid0_drive" {
    for_each = each.value.single_drive_raid0_configuration
    content {
      drive_slots = raid0_drive.value.drive_slots
      enable      = true
      object_type = "server.Profile"
      virtual_drive_policy = merge(raid0_drive.value.virtual_drive_policy, {
        additional_properties = "",
        class_id              = "storage.VirtualDrivePolicy"
        object_type           = "storage.VirtualDrivePolicy"
      })
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

#__________________________________________________________________
#
# Intersight Storage Policy > Drive Group
# GUI Location: Policies > Create Policy > Storage: Drive Group
#__________________________________________________________________

resource "intersight_storage_drive_group" "drive_groups" {
  depends_on = [
    intersight_storage_storage_policy.storage
  ]
  for_each   = local.drive_groups
  name       = each.value.name
  raid_level = each.value.raid_level
  storage_policy {
    moid = intersight_storage_storage_policy.storage[each.value.storage_policy].moid
    # object_type = "organization.Organization"
  }
  dynamic "automatic_drive_group" {
    for_each = toset(each.value.automatic_drive_group)
    content {
      class_id = "storage.ManualDriveGroup"
      drives_per_span = lookup(
        automatic_drive_group.value, "drives_per_span", length(regexall("^Raid0$", each.value.raid_level)
          ) > 0 ? 1 : length(regexall("^Raid1[0]?$", each.value.raid_level)
          ) > 0 ? 2 : length(regexall("^Raid5[0]?$", each.value.raid_level)
          ) > 0 ? 3 : length(regexall("^Raid6[0]$", each.value.raid_level)
        ) > 0 ? 4 : 2
      )
      drive_type         = lookup(automatic_drive_group.value, "drive_type", local.ldga.drive_type)
      minimum_drive_size = lookup(automatic_drive_group.value, "minimum_drive_size", local.ldga.minimum_drive_size)
      num_dedicated_hot_spares = lookup(
        automatic_drive_group.value, "num_dedicated_hot_spares", local.ldga.num_dedicated_hot_spares
      )
      number_of_spans = lookup(
        automatic_drive_group.value, "number_of_spans", length(regexall("^Raid(0|1|5|6)$", each.value.raid_level)
          ) > 0 ? 1 : length(regexall("^Raid(1|5|6)0?$", each.value.raid_level)
        ) > 0 ? 2 : 1
      )
      object_type          = "storage.ManualDriveGroup"
      use_remaining_drives = lookup(automatic_drive_group.value, "use_remaining_drives", local.ldga.use_remaining_drives)
    }
  }
  dynamic "manual_drive_group" {
    for_each = toset(each.value.manual_drive_group)
    content {
      class_id = "storage.ManualDriveGroup"
      dedicated_hot_spares = lookup(
        manual_drive_group.value, "dedicated_hot_spares", local.ldgm.dedicated_hot_spares
      )
      object_type = "storage.ManualDriveGroup"
      span_groups = [
        for sg in manual_drive_group.value.drive_array_spans : {
          additional_properties = ""
          class_id              = "storage.SpanDrives"
          object_type           = "storage.SpanDrives"
          slots                 = sg.slots
        }
      ]
    }
  }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
  dynamic "virtual_drives" {
    for_each = { for v in each.value.virtual_drives : v.name => v }
    content {
      additional_properties = ""
      boot_drive            = lookup(virtual_drives.value, "boot_drive", local.ldgv.boot_drive)
      class_id              = "storage.VirtualDriveConfiguration"
      expand_to_available   = lookup(virtual_drives.value, "expand_to_available", local.ldgv.expand_to_available)
      name                  = virtual_drives.key
      object_type           = "storage.VirtualDriveConfiguration"
      size                  = lookup(virtual_drives.value, "size", local.ldgv.size)
      virtual_drive_policy = [merge(merge(
        local.ldgv.virtual_drive_policy, lookup(
        virtual_drives.value, "virtual_drive_policy", local.ldgv.virtual_drive_policy)
        ), {
        additional_properties = ""
        class_id              = "storage.VirtualDrivePolicy"
        object_type           = "storage.VirtualDrivePolicy"
      })]
    }
  }
}
