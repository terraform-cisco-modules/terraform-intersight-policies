#__________________________________________________________________
#
# Data Objects - Pools and Policies
#__________________________________________________________________
data "intersight_search_search_item" "policies" {
  for_each = { for v in setsubtract(local.policy_types, ["vhba_template", "vnic_template"]) : v => v if length(compact(local.data_policies[v])) > 0 }
  additional_properties = jsonencode(
    { "ClassId" = "${local.policies[each.key].object}' and Name in ('${trim(join("', '", local.data_policies[each.key]), ", '")}') and ObjectType eq '${local.policies[each.key].object}" }
  )
}
data "intersight_search_search_item" "pools" {
  for_each = { for v in local.pool_types : v => v if length(compact(local.data_pools[v])) > 0 }
  additional_properties = length(regexall("wwnn|wwpn", each.key)
    ) > 0 ? jsonencode({ "ClassId" = "${local.pools[each.key].object}' and Name in ('${trim(join("', '", local.data_pools[each.key]), ", '")}') and PoolPurpose eq '${upper(each.key)}" }
  ) : jsonencode({ "ClassId" = "${local.pools[each.key].object}' and Name in ('${trim(join("', '", local.data_pools[each.key]), ", '")}') and ObjectType eq '${local.pools[each.key].object}" })
}
data "intersight_vnic_vhba_template" "map" { for_each = { for v in [0] : v => v if length(local.data_policies["vhba_template"]) > 0 } }
data "intersight_vnic_vnic_template" "map" { for_each = { for v in [0] : v => v if length(local.data_policies["vnic_template"]) > 0 } }

