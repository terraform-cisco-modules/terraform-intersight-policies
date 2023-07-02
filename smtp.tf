#__________________________________________________________________
#
# Intersight SMTP Policy
# GUI Location: Policies > Create Policy > SMTP
#__________________________________________________________________

resource "intersight_smtp_policy" "smtp" {
  for_each = { for v in lookup(local.policies, "smtp", []) : v.name => v }
  description = lookup(
  each.value, "description", "${local.name_prefix.smtp}${each.key}${local.name_suffix.smtp} SMTP Policy.")
  enabled      = lookup(each.value, "enable_smtp", local.defaults.smtp.enable_smtp)
  min_severity = lookup(each.value, "minimum_severity", local.defaults.smtp.minimum_severity)
  name         = "${local.name_prefix.smtp}${each.key}${local.name_suffix.smtp}"
  sender_email = lookup(
    each.value, "smtp_alert_sender_address", local.defaults.smtp.smtp_alert_sender_address
  )
  smtp_port = lookup(each.value, "smtp_port", local.defaults.smtp.smtp_port)
  smtp_recipients = lookup(
    each.value, "mail_alert_recipients", local.defaults.smtp.mail_alert_recipients
  )
  smtp_server = each.value.smtp_server_address
  organization {
    moid        = local.orgs[var.organization]
    object_type = "organization.Organization"
  }
  dynamic "tags" {
    for_each = lookup(each.value, "tags", var.tags)
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
