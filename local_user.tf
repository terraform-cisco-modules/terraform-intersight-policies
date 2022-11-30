#__________________________________________________________________
#
# Intersight Local User Policy
# GUI Location: Policies > Create Policy > Local User
#__________________________________________________________________

resource "intersight_iam_end_point_user_policy" "local_user" {
  for_each    = local.local_user
  description = lookup(each.value, "description", "${each.value.name} Local User Policy.")
  name        = each.value.name
  password_properties {
    enable_password_expiry   = each.value.enable_password_expiry
    enforce_strong_password  = each.value.enforce_strong_password
    force_send_password      = each.value.always_send_user_password
    grace_period             = each.value.grace_period
    notification_period      = each.value.notification_period
    password_expiry_duration = each.value.password_expiry_duration
    password_history         = each.value.password_history
  }
  organization {
    moid        = local.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  dynamic "tags" {
    for_each = each.value.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
#____________________________________________________________________
#
# Intersight Local User - Add New User
# GUI Location: Policies > Create Policy > Local User > Add New User
#____________________________________________________________________

resource "intersight_iam_end_point_user" "users" {
  depends_on = [
    intersight_iam_end_point_user_policy.local_user
  ]
  for_each = local.users
  name     = each.value.name
  organization {
    moid        = local.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
}

resource "intersight_iam_end_point_user_role" "user_role" {
  depends_on = [
    data.intersight_iam_end_point_role.roles,
    intersight_iam_end_point_user.users
  ]
  for_each = local.users
  enabled  = each.value.enabled
  password = length(
    regexall("^1$", each.value.password)
    ) > 0 ? each.value.local_user_password_1 : length(
    regexall("^2$", each.value.password)
    ) > 0 ? each.value.local_user_password_2 : length(
    regexall("^3$", each.value.password)
    ) > 0 ? each.value.local_user_password_3 : length(
    regexall("^4$", each.value.password)
  ) > 0 ? each.value.local_user_password_4 : each.value.local_user_password_5
  end_point_role {
    moid        = data.intersight_iam_end_point_role.roles[each.value.role].results[0].moid
    object_type = "iam.EndPointRole"
  }
  end_point_user {
    moid        = intersight_iam_end_point_user.users[each.value.name].moid
    object_type = "iam.EndPointUser"
  }
  end_point_user_policy {
    moid        = intersight_iam_end_point_user_policy.local_user[each.value.local_user].moid
    object_type = "iam.EndPointUserPolicy"
  }
}
