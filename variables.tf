variable "zone_ids" {
  description = "Map of zone IDs indexed by domain name (when issuing a certificate spanning multiple zones)"
  type        = map(string)
}