#__________________________________________________________________
#
# Intersight SNMP Policy
# GUI Location: Policies > Create Policy > SNMP
#__________________________________________________________________

resource "intersight_snmp_policy" "snmp" {
  for_each = local.snmp
  access_community_string = length(
    regexall("1", each.value.access_community_string)
    ) > 0 ? var.access_community_string_1 : length(
    regexall("2", each.value.access_community_string)
    ) > 0 ? var.access_community_string_2 : length(
    regexall("3", each.value.access_community_string)
    ) > 0 ? var.access_community_string_3 : length(
    regexall("4", each.value.access_community_string)
    ) > 0 ? var.access_community_string_3 : length(
    regexall("5", each.value.access_community_string)
  ) > 0 ? var.access_community_string_5 : ""
  community_access = each.value.snmp_community_access
  description      = lookup(each.value, "description", "${each.value.name} SNMP Policy.")
  enabled          = each.value.enable_snmp
  engine_id        = each.value.snmp_engine_input_id
  name             = each.value.name
  snmp_port        = each.value.snmp_port
  sys_contact      = each.value.system_contact
  sys_location     = each.value.system_location
  trap_community   = var.trap_community_string
  v2_enabled = length(compact([var.trap_community_string])
    ) > 0 || length(compact([var.snmp_trap_community_1])
    ) > 0 || length(compact([var.snmp_trap_community_2])
    ) > 0 || length(compact([var.snmp_trap_community_3])
    ) > 0 || length(compact([var.snmp_trap_community_4])
    ) > 0 || length(compact([var.snmp_trap_community_5])
  ) > 0 ? true : false
  v3_enabled = length(each.value.snmp_users) > 0 ? true : false
  organization {
    moid        = local.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  dynamic "profiles" {
    for_each = { for v in each.value.profiles : v.name => v }
    content {
      moid        = var.domains[profiles.value.name].moid
      object_type = profiles.value.object_type
    }
  }
  dynamic "snmp_traps" {
    for_each = { for v in each.value.snmp_trap_destinations : v.hostname => v }
    content {
      community = length(
        regexall("1", coalesce(snmp_traps.value.community_string, 10))
        ) > 0 ? var.snmp_trap_community_1 : length(
        regexall("2", coalesce(snmp_traps.value.community_string, 10))
        ) > 0 ? var.snmp_trap_community_2 : length(
        regexall("3", coalesce(snmp_traps.value.community_string, 10))
        ) > 0 ? var.snmp_trap_community_3 : length(
        regexall("4", coalesce(snmp_traps.value.community_string, 10))
        ) > 0 ? var.snmp_trap_community_4 : length(
        regexall("5", coalesce(snmp_traps.value.community_string, 10))
      ) > 0 ? var.snmp_trap_community_5 : ""
      destination = snmp_traps.value.hostname
      enabled     = snmp_traps.value.enable
      port        = snmp_traps.value.port
      type        = snmp_traps.value.trap_type
      nr_version  = length(compact([snmp_traps.value.user])) > 0 ? "V3" : "V2"
      user        = snmp_traps.value.user
    }
  }
  dynamic "snmp_users" {
    for_each = { for v in each.value.snmp_users : v.name => v }
    content {
      auth_password = length(
        regexall("1", coalesce(snmp_users.value.auth_password, 10))
        ) > 0 ? var.snmp_auth_password_1 : length(
        regexall("2", coalesce(snmp_users.value.auth_password, 10))
        ) > 0 ? var.snmp_auth_password_2 : length(
        regexall("3", coalesce(snmp_users.value.auth_password, 10))
        ) > 0 ? var.snmp_auth_password_3 : length(
        regexall("4", coalesce(snmp_users.value.auth_password, 10))
        ) > 0 ? var.snmp_auth_password_3 : length(
        regexall("5", coalesce(snmp_users.value.auth_password, 10))
      ) > 0 ? var.snmp_auth_password_5 : ""
      auth_type = snmp_users.value.auth_type
      name      = snmp_users.value.name
      privacy_password = length(
        regexall("1", coalesce(snmp_users.value.privacy_password, 10))
        ) > 0 ? var.snmp_privacy_password_1 : length(
        regexall("2", coalesce(snmp_users.value.privacy_password, 10))
        ) > 0 ? var.snmp_privacy_password_2 : length(
        regexall("3", coalesce(snmp_users.value.privacy_password, 10))
        ) > 0 ? var.snmp_privacy_password_3 : length(
        regexall("4", coalesce(snmp_users.value.privacy_password, 10))
        ) > 0 ? var.snmp_privacy_password_3 : length(
        regexall("5", coalesce(snmp_users.value.privacy_password, 10))
      ) > 0 ? var.snmp_privacy_password_5 : ""
      privacy_type   = snmp_users.value.privacy_type
      security_level = snmp_users.value.security_level
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
