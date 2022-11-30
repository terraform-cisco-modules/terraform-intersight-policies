#__________________________________________________________________
#
# Intersight SMTP Policy
# GUI Location: Policies > Create Policy > SMTP
#__________________________________________________________________

resource "intersight_smtp_policy" "smtp" {
  for_each     = { for v in lookup(local.policies, "smtp", []) : v.name => v }
  description  = lookup(each.value, "description", "${each.value.name} LDAP Policy.")
  enabled      = lookup(each.value, "enable_smtp", local.defaults.intersight.policies.smtp.enable_smtp)
  min_severity = lookup(each.value, "minimum_severity", local.defaults.intersight.policies.smtp.minimum_severity)
  name         = "${each.key}${local.defaults.intersight.policies.smtp.name_suffix}"
  sender_email = lookup(
    each.value, "smtp_alert_sender_address", local.defaults.intersight.policies.smtp.smtp_alert_sender_address
  )
  smtp_port = lookup(each.value, "smtp_port", local.defaults.intersight.policies.smtp.smtp_port)
  smtp_recipients = lookup(
    each.value, "mail_alert_recipients", local.defaults.intersight.policies.smtp.mail_alert_recipients
  )
  smtp_server = each.value.smtp_server_address
  organization {
    moid        = local.orgs[lookup(each.value, "organization", var.organization)]
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
