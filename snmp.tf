#__________________________________________________________________
#
# Intersight SNMP Policy
# GUI Location: Policies > Create Policy > SNMP
#__________________________________________________________________
resource "intersight_snmp_policy" "map" {
  for_each                = local.snmp
  access_community_string = local.ps.snmp.access_community_string[each.value.access_community_string]
  community_access        = each.value.snmp_community_access
  description             = coalesce(each.value.description, "${each.value.name} SNMP Policy.")
  enabled                 = each.value.enable_snmp
  engine_id               = each.value.snmp_engine_input_id
  name                    = each.value.name
  snmp_port               = each.value.snmp_port
  sys_contact             = each.value.system_contact
  sys_location            = each.value.system_location
  trap_community          = local.ps.snmp.trap_community_string[each.value.trap_community_string]
  v2_enabled              = length(each.value.v2_enabled) > 0 ? true : false
  v3_enabled              = length(each.value.snmp_users) > 0 ? true : false
  organization { moid = var.orgs[each.value.organization] }
  dynamic "snmp_traps" {
    for_each = { for v in each.value.snmp_trap_destinations : v.destination_address => v }
    content {
      community   = local.ps.snmp.trap_community_string[each.value.trap_community_string]
      destination = snmp_traps.key
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
      auth_password    = local.ps.snmp.auth_password[snmp_users.value.auth_password]
      auth_type        = snmp_users.value.auth_type
      name             = snmp_users.value.name
      privacy_password = local.ps.snmp.privacy_password[snmp_users.value.privacy_password]
      privacy_type     = snmp_users.value.security_level == "AuthPriv" ? snmp_users.value.privacy_type : "NA"
      security_level   = snmp_users.value.security_level
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
