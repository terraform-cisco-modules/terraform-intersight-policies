#__________________________________________________________________
#
# Intersight LDAP Policy
# GUI Location: Policies > Create Policy > LDAP
#__________________________________________________________________
resource "intersight_iam_ldap_policy" "map" {
  for_each    = local.ldap
  description = coalesce(each.value.description, "${each.value.name} LDAP Policy.")
  name        = each.value.name
  enabled     = each.value.enable_ldap
  base_properties {
    # Base Settings
    base_dn = each.value.base_settings.base_dn
    domain  = each.value.base_settings.domain
    timeout = each.value.base_settings.timeout != null ? each.value.base_settings.timeout : 0
    # Enable LDAP Encryption
    enable_encryption = each.value.enable_encryption
    # Binding Parameters
    bind_method = each.value.binding_parameters.bind_method
    bind_dn     = each.value.binding_parameters.bind_dn
    password    = local.ps.ldap.password[each.value.binding_parameters.password]
    # Search Parameters
    attribute       = each.value.search_parameters.attribute
    filter          = each.value.search_parameters.filter
    group_attribute = each.value.search_parameters.group_attribute
    # Group Authorization
    enable_group_authorization = each.value.enable_group_authorization
    enable_nested_group_search = each.value.nested_group_search_depth == 0 ? false : true
    nested_group_search_depth  = each.value.nested_group_search_depth == 0 ? 128 : each.value.nested_group_search_depth
  }
  # Configure LDAP Servers
  enable_dns = length(compact([each.value.ldap_from_dns.search_domain])
  ) > 0 || length(compact([each.value.ldap_from_dns.search_forest])) > 0 ? true : false
  dns_parameters {
    nr_source     = each.value.ldap_from_dns.source
    search_domain = each.value.ldap_from_dns.search_domain
    search_forest = each.value.ldap_from_dns.search_forest
  }
  user_search_precedence = each.value.user_search_precedence
  organization { moid = var.orgs[each.value.org] }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

#____________________________________________________________________
#
# Intersight LDAP Policy > Add New LDAP Group
# GUI Location: Policies > Create Policy > LDAP > Add New LDAP Group
#____________________________________________________________________
data "intersight_iam_end_point_role" "map" {
  for_each = { for v in toset(local.roles) : v => v }
  name     = each.value
  type     = "IMC"
}

resource "intersight_iam_ldap_group" "map" {
  depends_on = [
    data.intersight_iam_end_point_role.map,
    intersight_iam_ldap_policy.map
  ]
  for_each = local.ldap_groups
  domain   = each.value.domain
  group_dn = each.value.group_dn
  name     = each.value.name
  end_point_role {
    moid        = data.intersight_iam_end_point_role.map[each.value.end_point_role].results[0].moid
    object_type = "iam.EndPointRole"
  }
  ldap_policy {
    moid = intersight_iam_ldap_policy.map[each.value.ldap_policy].moid
  }
}

#__________________________________________________________________
#
# Intersight LDAP Policy - Server
# GUI Location: Policies > Create Policy > LDAP Policy > Server
#__________________________________________________________________
resource "intersight_iam_ldap_provider" "map" {
  for_each = local.ldap_servers
  depends_on = [
    intersight_iam_ldap_policy.map
  ]
  ldap_policy { moid = intersight_iam_ldap_policy.map[each.value.ldap_policy].moid }
  port   = each.value.port
  server = each.value.server
  vendor = each.value.vendor
}

