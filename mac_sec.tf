#__________________________________________________________________
#
# Intersight MACsec Policy
# GUI Location: Policies > Create Policy > MACsec
#__________________________________________________________________
resource "intersight_fabric_mac_sec_policy" "map" {
  for_each               = local.mac_sec
  cipher_suite           = each.value.cipher_suite
  confidentiality_offset = each.value.confidentiality_offset
  description            = coalesce(each.value.description, "${each.value.name} MacSec Policy.")
  include_icv_indicator  = each.value.include_icv_indicator
  key_server_priority    = each.value.key_server_priority
  mac_sec_ea_pol {
    ea_pol_ethertype   = each.value.eapol_configurations.ether_type
    ea_pol_mac_address = each.value.eapol_configurations.mac_address
  }
  name = each.value.name
  organization { moid = var.orgs[each.value.org] }
  primary_key_chain {
    additional_properties = jsonencode({
      SecKeys = [for v in each.value.mac_sec_primary_key_chain.add_key :
        {
          CryptographicAlgorithm = v.cryptographic_algorithm
          Id                     = v.id
          #KeyType                = "Type-6" # Type-0 Type-6 Type-7
          ObjectType           = "fabric.SecKey"
          OctetString          = local.ps.mac_sec.primary_key_chain[v.secret]
          SendLifetimeDuration = 0
          SendLifetimeEndTime  = v.key_lifetime.always_active == false ? v.key_lifetime.end_time : "0001-01-01T00:00:00Z"
          SendLifetimeInfinite = length(regexall("0001-01-01T00:00:00Z", v.key_lifetime.end_time)
          ) == 0 && v.key_lifetime.always_active == false ? true : false
          SendLifetimeStartTime = v.key_lifetime.always_active == false ? v.key_lifetime.start_time : "0001-01-01T00:00:00Z"
          SendLifetimeTimeZone  = v.key_lifetime.always_active == false ? v.key_lifetime.timezone : "UTC"
          SendLifetimeUnlimited = v.key_lifetime.always_active
        }
      ]

    })
    name = each.value.mac_sec_primary_key_chain.primary_key_chain_name
  }
  replay_window_size = each.value.replay_window_size
  sak_expiry_time    = each.value.sak_expiry_time
  security_policy    = each.value.security_policy
  dynamic "fallback_key_chain" {
    for_each = { for e in each.value.mac_sec_fallback_key_chain : e.key => e }
    content {
      additional_properties = jsonencode({
        SecKeys = [for v in each.value.add_key :
          {
            CryptographicAlgorithm = v.cryptographic_algorithm
            Id                     = v.id
            #KeyType                = "Type-6" # Type-0 Type-6 Type-7
            ObjectType           = "fabric.SecKey"
            OctetString          = local.ps.mac_sec.fallback_key_chain[v.secret]
            SendLifetimeDuration = 0
            SendLifetimeEndTime  = v.key_lifetime.always_active == false ? v.key_lifetime.end_time : "0001-01-01T00:00:00Z"
            SendLifetimeInfinite = length(regexall("0001-01-01T00:00:00Z", v.key_lifetime.end_time)
            ) == 0 && v.key_lifetime.always_active == false ? true : false
            SendLifetimeStartTime = v.key_lifetime.always_active == false ? v.key_lifetime.start_time : "0001-01-01T00:00:00Z"
            SendLifetimeTimeZone  = v.key_lifetime.always_active == false ? v.key_lifetime.timezone : "UTC"
            SendLifetimeUnlimited = v.key_lifetime.always_active
          }
      ] })
      name = each.value.fallback_key_chain_name
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
