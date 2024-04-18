resource "aws_acm_certificate" "main" {
  provider                  = aws.region
  domain_name               = keys(var.zone_ids)[0]
  subject_alternative_names = slice(keys(var.zone_ids), 1, length(var.zone_ids))
  validation_method         = "DNS"
}

resource "aws_route53_record" "validation" {
  provider = aws.region
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = lookup(var.zone_ids, "${each.key}")
}

resource "aws_acm_certificate_validation" "main" {
  provider                = aws.region
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for rec in aws_route53_record.validation : rec.fqdn]
}