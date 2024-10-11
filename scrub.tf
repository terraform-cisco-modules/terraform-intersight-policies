#__________________________________________________________________
#
# Intersight Scrub Policy
# GUI Location: Policies > Create Policy > Scrub
#__________________________________________________________________
resource "intersight_compute_scrub_policy" "map" {
  for_each    = local.scrub
  description = coalesce(each.value.description, "${each.value.name} Scrub Policy.")
  name        = each.value.name
  scrub_targets = anytrue([each.value.bios, each.value.disk]) ? compact(concat([
    length(regexall(true, each.value.bios)) > 0 ? "BIOS" : ""], [
    length(regexall(true, each.value.disk)) > 0 ? "Disk" : ""]
  )) : []
  organization { moid = var.orgs[each.value.org] }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
