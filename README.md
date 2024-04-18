# AWS Certificate Manager (ACM) Terraform module

A Terraform module which requests and validates ACM certificates on AWS, using DNS validation with Route53. Based on https://github.com/manicminer/terraform-aws-acm-certificate updated for 2024 and solely dedicated to issue a single cert spanning multiple hosted zones.

## Inputs

| Name | Description | Type | Required |
|------|-------------|:----:|:-----:|
| zone_ids | Map having domain names as keys, Route53 zone ID as values | string | yes |

Use `zone_ids` when you are issuing a cert for multiple domains served from different zones, e.g. different TLDs.


### Multi zone example

Note that you will need to specify a zone ID for each unique domain, including subdomains and wildcards

```hcl
module "my_acm_certificate" {
  source = "./my_acm_certificate"
  zone_ids = {
    "example.com"        = data.aws_route53_zone.example-com.zone_id
    "*.example.com"      = data.aws_route53_zone.example-com.zone_id
    "*.demo.example.com" = data.aws_route53_zone.example-com.zone_id

    "example2.com"        = data.aws_route53_zone.example2-com.zone_id
    "*.example2.com"      = data.aws_route53_zone.example2-com.zone_id
    "*.demo.example2.com" = data.aws_route53_zone.example2-com.zone_id
  }

  providers = {
    aws.virginia = aws.virginia
  }
}
```

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN of the certificate |


## License

No support, no guarantees, use at your own risk

## Notes

Be aware that

> The default quota is 10 domain names for each ACM certificate. 

Source: https://docs.aws.amazon.com/acm/latest/userguide/acm-limits.html