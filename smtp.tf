#__________________________________________________________________
#
# Intersight SMTP Policy
# GUI Location: Policies > Create Policy > SMTP
#__________________________________________________________________

resource "intersight_smtp_policy" "map" {
  for_each        = local.smtp
  description     = coalesce(each.value.description, "${each.value.name} SMTP Policy.")
  enabled         = each.value.enable_smtp
  min_severity    = each.value.minimum_severity
  name            = each.value.name
  sender_email    = each.value.smtp_alert_sender_address
  smtp_port       = each.value.smtp_port
  smtp_recipients = each.value.mail_alert_recipients
  smtp_server     = each.value.smtp_server_address
  organization {
    moid        = var.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
